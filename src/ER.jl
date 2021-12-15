"""
The ER sampler consists of:
    - N, the set of nodes
    - k, Integer, hyperedge size
In the ER model, all edges have the same probability of placement.
You may use the function ER_sampler below to generate the sampler.
"""
struct ER_sampler{N, K} <: Random.Sampler{NTuple{K, eltype(N)}}
    nodes::N
end

"""
Generate the ER_sampler
2 parameters:
- n :: Integer, node count
- k :: Integer, hyperedge size
"""
function ER_sampler(n::Integer, k::Integer)
    ER_sampler{Base.OneTo{typeof(n)}, k}(Base.OneTo(n))
end

function Base.rand(rng::AbstractRNG, s::ER_sampler{T, K}) where {T, K}
    ntuple(i -> rand(rng, s.nodes), Val{K}())
end
