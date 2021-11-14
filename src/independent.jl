using Random: Sampler

struct Independent{T, L} <: Sampler{Vector{T}}
    source::Sampler{T}
    length::L
end

Base.rand(rng::AbstractRNG, x::Independent{<:Any, <:Sampler{<:Integer}}) = rand(rng, x.source, rand(rng, x.length))
Base.rand(rng::AbstractRNG, x::Independent{<:Any, <:Integer}) = rand(rng, x.source, x.length)
