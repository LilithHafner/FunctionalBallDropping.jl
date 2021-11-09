using Distributions
using Unzip: unzip
using Random

struct Kronecker_sampler{T} <: Random.Sampler{Vector{T}} #TODO make edge size static and edge type abstract
    k::Int
    bits::Int
    power::Int
    is::Vector{Vector{T}}
    dist::Categorical{Float64, Vector{Float64}}
    remainder::Vector{Int}
end

"""
    Kronecker_sampler(initializer, power, T=Int)

Create an efficient edge sampler whose probability distribution follows the specified
kroneker model.

Draw a hypergraph from the sampler with `rand(sampler, edges)`.
"""
function Kronecker_sampler(initializer::AbstractArray, power::Integer; T::Type=Int, space=1,
    inner_power = max(1, min(power, Int(log(max(1,space)) ÷ log(max(2,length(initializer)))))),
    outer_power = cld(power, inner_power))

    Base.require_one_based_indexing(initializer)

    inner_power = cld(power, outer_power)
    remainder = collect(size(initializer)) .^ (power - inner_power*(outer_power-1))

    initializer = kronecker_power(initializer, inner_power)
    is = [collect(Tuple(i)).-one(T) for i in vec(eachindex(IndexCartesian(), initializer))]
    dist = Categorical(vec(initializer) ./ sum(initializer))

    k = length(axes(initializer))
    bits = maximum(maximum(used_bits.(i)) for i in is)
    #bits = used_bits(maximum(size(initializer)).^inner_power)

    Kronecker_sampler{T}(k, bits, outer_power, is, dist, remainder)
end

"""
    rand(s::Kronecker_sampler)
    rand(s::Kronecker_sampler, e::Integer)

Draw an edge or a hypergraph with `e` edges from the sampler `s`.
"""
function Base.rand(rng::AbstractRNG, s::Kronecker_sampler{T}) where T
    edge = [T(v%r) for (v,r) in zip(s.is[rand(rng, s.dist)], s.remainder)]
    for i in 1:(s.power-1)
        for (j,v) in enumerate(s.is[rand(rng, s.dist)])
            edge[j] |= v << (i*s.bits)
        end
    end
    edge
end
