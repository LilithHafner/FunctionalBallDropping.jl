#TODO merge into StatsBase.jl & potentially make types there abstract

using Random
using StatsBase: make_alias_table!

struct OneToInf <: AbstractVector{Int} end
Base.size(::OneToInf) = (typemax(Int),)
Base.getindex(::OneToInf, x::Integer) = x
Base.iterate(::OneToInf, state=1) = (state, state+1)
Base.eltype(::Type{OneToInf}) = Int
Base.IteratorSize(::Type{OneToInf}) = Base.IsInfinite()
Base.show(io::IO, X::OneToInf) = print(io, "OneToInf()")
Base.:(==)(::OneToInf, ::OneToInf) = true

struct AliasTable{T, S} <: Random.Sampler{T} where {S <: AbstractVector{T}}
    accept::Vector{Float64}
    alias::Vector{Int}
    support::S
end

function AliasTable(probs::AbstractVector{<:Real}, support::AbstractVector=OneToInf())
    AliasTable!(Float64.(probs), support)
end
function AliasTable!(probs::AbstractVector{Float64}, support::AbstractVector=OneToInf())
    Base.has_offset_axes(probs, support) && throw(ArgumentError("offset arrays are not supported but got an array with index other than 1"))
    n = length(probs)
    n > 0 || throw(ArgumentError("The input probability vector is empty."))
    checkbounds(Bool, support, axes(probs, 1)) || throw(BoundsError("probabilities extend past support"))
    alias = similar(probs, Int)
    sum_probs = sum(probs)
    0 < sum_probs < Inf || throw(ArgumentError("sum(probs) = $sum_probs"))
    make_alias_table!(probs, sum_probs, probs, alias)
    AliasTable{eltype(support), typeof(support)}(probs, alias, support)
end

# with an alias table that has a high proportion of guaranteed acceptance, this can be
# optimized to reduce the number of times u needs to be computed.
# StatsBase.make_alias_table! does not produce such a table.
function Random.rand(rng::AbstractRNG, s::AliasTable)
    i = rand(rng, eachindex(s.accept))
    u = rand(rng)
    @inbounds s.support[u < s.accept[i] ? i : s.alias[i]]
end

Base.:(==)(a::AliasTable, b::AliasTable) =
    a.accept == b.accept && a.support == b.support && a.alias[a.accept .!= 1] == b.alias[b.accept .!= 1]


# I think this is faster to make, faster to sample, more general, and better integrated with
# Random than Distributions.jl's version and much more usable & complete than StatsBase.jl's
# version.

#=
using BenchmarkTools, StatsBase

#FBD
source = rand(1000);
@btime AliasTable($source); # 7.646 μs (4 allocations: 31.75 KiB)
at = AliasTable(source)
@btime rand($at, 1000); # 12.331 μs (1 allocation: 7.94 KiB)

#Distributions
using Distributions
@btime sampler(Categorical($source ./ sum($source))); # 10.933 μs (11 allocations: 47.77 KiB)
at2 = sampler(Categorical(source ./ sum(source)))
@btime rand($at2, 1000); # 22.882 μs (1 allocation: 7.94 KiB)

#StatsBase
function f(weights)
    probs = similar(source)
    alias = similar(source, Int)
    make_alias_table!(weights, sum(source), probs, alias)
    probs, alias
end
@btime f($source);
probs, alias = f(source) # 7.525 μs (7 allocations: 31.81 KiB)
#no samplng method available.

=#
