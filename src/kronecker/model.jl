using Distributions
using Random
using StaticArrays

struct Kronecker_sampler{T, K} <: Random.Sampler{NTuple{K, T}} #TODO make edge type abstract
    power::Int
    dist::AliasTable{NTuple{K, T}, Vector{NTuple{K, T}}}
    initializer_size::T
    remainder::T
end

"""
    Kronecker_sampler(initializer, power; T=Int, space=1)

Create an efficient edge sampler whose probability distribution follows the specified
kroneker model.

Giving the sampler an adequite (but not excessive) amount of space may speed up generation
by up to 2x. `space = edge_count ÷ 100` may be a good heuristic. The sampler will take up
O(`sizeof(t)*ndims(initailizer)*space`) space with a constant factor around 4 bytes.

Draw a hypergraph from the sampler with `rand(sampler, edges)`.
"""
function Kronecker_sampler(initializer::AbstractArray, power::Integer; Type::Type{T}=Int, space=1,
    inner_power = max(1, min(power, Int(log(max(1,space)) ÷ log(max(2,length(initializer)))))),
    outer_power = cld(power, inner_power)) where T <: Integer

    Base.require_one_based_indexing(initializer)
    initializer_size = first(size(initializer))
    all(size(initializer) .== initializer_size) || ArgumentError("initializer must be square")

    inner_power = cld(power, outer_power)
    remainder = initializer_size ^ (power - inner_power*(outer_power-1))

    initializer = kronecker_power(initializer, inner_power)
    is = [Tuple(i).-one(T) for i in vec(eachindex(IndexCartesian(), initializer))]
    dist = AliasTable(vec(initializer), is)

    K = ndims(initializer)

    Kronecker_sampler{T, K}(outer_power, dist, initializer_size, remainder)
end

"""
    rand(s::Kronecker_sampler)
    rand(s::Kronecker_sampler, e::Integer)

Draw an edge or a hypergraph with `e` edges from the sampler `s`.
"""
function Base.rand(rng::AbstractRNG, s::Kronecker_sampler{T, K}) where {T, K}
    mult = s.remainder
    edge = MVector{K}(rand(rng, s.dist)) .% mult
    for _ in 1:(s.power-1)
        edge .+= rand(rng, s.dist) .* mult
        mult *= s.initializer_size
    end
    NTuple{K}(edge)
end
