using Combinatorics: with_replacement_combinations
using Distributions
using StatsBase: countmap

struct DCHSBM_sampler
    groups::AbstractVector
    ms::AbstractVector
    distribution_of_ms::Sampleable{Univariate, Discrete}
    expected_edges::Real
end

"""
    DCHSBM_sampler(Z, θ, kmax[, scaling_factor])

Create a hypergraph sampler whose probability distribution follows the specified
degree corrected hyperstochastic block model.

Draw a hypergraph from the sampler with `rand(sampler)`.

# Arguments
- `Z::AbstractVector{<:Integer}` the group assignment of each node
- `θ::AbstractVector{<:Real}` the degree correction weight of each node.
- `kmax::Integer` is the largest possible hyperedge size the graph will generate
- `scaling_factor::Float64` is the largest equivalent edge-placement probability for the graph
`Z` and `θ` must have the same length.

# Runtime

This method:
O(`tensor_cells * kmax + nodes`) ≈
400ns * tensor_cells * kmax + 30ns * nodes

Sampling:
O(`edges * kmax`) ≈
150ns * edges * kmax + 1300ns * edges
"""
function DCHSBM_sampler(Z::AbstractVector{<:Integer}, θ::AbstractVector{<:Real}, kmax::Integer, scaling_factor::Float64)
    function affinity(m)
        (number_of_groups_affinity_function(m, scaling_factor)
        * prod(group_sizes[m])
        / prod(factorial.(values(countmap(m; alg=:dict)))))
    end

    #Note that sorting is O(n) here with a moderate constant factor, and sort checking is practically free
    @assert axes(Z) == axes(θ)
    if !issorted(Z)
        perm = sortperm(Z)
        Z = Z[perm]
        θ = θ[perm]
    end

    groups, group_sizes, start = [], [], 1
    while start <= length(Z)
        next = start
        while next <= length(Z) && Z[next] == Z[start]; next += 1 end
        weights = θ[start:next-1]
        push!(groups, sampler(DiscreteNonParametric(start:next-1, weights ./ sum(weights))))
        push!(group_sizes, next-start)
        start = next
    end

    ms = collect(with_replacement_combinations(axes(groups, 1), kmax))
    ms_weights = affinity.(ms)
    expected_edges = sum(ms_weights)
    distribution_of_ms = sampler(Categorical(ms_weights ./ expected_edges))

    DCHSBM_sampler(groups, ms, distribution_of_ms, expected_edges)
end

"""
    rand_round(x::Real)

Round a number to one of the two nearest integers according to proximity so that
the expectation value of `rand_round(x)` is `x`.
"""
function rand_round(x::Real)
    n = Int(floor(x))
    n + (rand() < (x-n))
end

"""
    rand(s::DCHSBM_sampler[, edges::Integer])

Draw a hypergraph from the sampler `s`,
optionally overriding the expected number of edges.
"""
function Base.rand(s::DCHSBM_sampler; edges=rand_round(s.expected_edges)::Integer)
    [[rand(s.groups[group]) for group in s.ms[rand(s.distribution_of_ms)]] for _ in 1:edges]
end
