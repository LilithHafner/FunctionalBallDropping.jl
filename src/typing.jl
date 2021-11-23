using Random: Sampler
using Distributions: Geometric

struct Typing_sampler{DL, DT, T} <: Sampler{Vector{Vector{T}}}
    hyperdegree::Int
    length::DL
    letter::DT
end
Typing_sampler(hyperdegree::Int, n::Int) =
    Typing_sampler{Geometric{Float64}, UnitRange{Int}, Int}(
        hyperdegree, Geometric(1/(n+1)), 1:n)
Typing_sampler(hyperdegree, space_weight, weights, letters) =
    Typing_sampler{Geometric{Float64}, AliasTable{Char, Vector{Char}}, Char}(
        hyperdegree, Geometric(space_weight), AliasTable(weights, letters))

Base.rand(rng::AbstractRNG, s::Typing_sampler) =
    [rand(rng, s.letter, rand(rng, s.length)) for _ in 1:s.hyperdegree]
