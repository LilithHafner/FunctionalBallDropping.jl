using Distributions
using Random

struct Kronecker_sampler{T} <: Random.Sampler{Vector{T}} #TODO make edge size static and edge type abstract
    k::Int
    bits::Int
    power::Int
    dist::AliasTable{Vector{T}, Vector{Vector{T}}}
    remainder::Vector{T}
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
function Kronecker_sampler(initializer::AbstractArray, power::Integer; T::Type=Int, space=1,
    inner_power = max(1, min(power, Int(log(max(1,space)) ÷ log(max(2,length(initializer)))))),
    outer_power = cld(power, inner_power))

    Base.require_one_based_indexing(initializer)

    inner_power = cld(power, outer_power)
    remainder = collect(size(initializer)) .^ (power - inner_power*(outer_power-1))

    initializer = kronecker_power(initializer, inner_power)
    is = [collect(Tuple(i)).-one(T) for i in vec(eachindex(IndexCartesian(), initializer))]
    dist = AliasTable(vec(initializer), is)

    k = length(axes(initializer))
    bits = maximum(maximum(used_bits.(i)) for i in is)
    #bits = used_bits(maximum(size(initializer)).^inner_power)

    Kronecker_sampler{T}(k, bits, outer_power, dist, remainder)
end

"""
    rand(s::Kronecker_sampler)
    rand(s::Kronecker_sampler, e::Integer)

Draw an edge or a hypergraph with `e` edges from the sampler `s`.
"""
function Base.rand(rng::AbstractRNG, s::Kronecker_sampler{T}) where T
    edge = rand(rng, s.dist) .% s.remainder
    for i in 1:(s.power-1)
        for (j,v) in enumerate(rand(rng, s.dist))
            edge[j] |= v << (i*s.bits)
        end
    end
    edge
end
