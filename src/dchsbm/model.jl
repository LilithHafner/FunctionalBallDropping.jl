using Combinatorics: with_replacement_combinations
using Distributions
using StatsBase: countmap

struct DCHSBM_sampler{K, I <: Integer} <: Random.Sampler{NTuple{K, I}} # TODO make fully parameterized
    groups::Vector{AliasTable{I, UnitRange{I}}}
    ms::AliasTable{NTuple{K, I}, Vector{NTuple{K, I}}}#TODO try inline groups
end

"""
    DCHSBM_sampler(Z, θ, kmax)

Create a hypergraph sampler whose probability distribution follows the specified
degree corrected hyperstochastic block model.

Draw a hypergraph from the sampler with `rand(sampler)`.

# Arguments
- `Z::AbstractVector{<:Integer}` the group assignment of each node
- `θ::AbstractVector{<:Real}` the degree correction weight of each node.
- `kmax::Integer` is the largest possible hyperedge size the graph will generate
`Z` and `θ` must have the same length.

# Runtime

This method:
O(`tensor_cells * kmax + nodes`) ≈
400ns * tensor_cells * kmax + 30ns * nodes

Sampling:
O(`edges * kmax`) ≈
150ns * edges * kmax + 1300ns * edges
"""
function DCHSBM_sampler(Z::AbstractVector{<:Integer}, θ::AbstractVector{<:Real}, kmax::Integer)
    #Note that sorting is O(n) here with a moderate constant factor, and sort checking is practically free
    @assert axes(Z) == axes(θ)
    if !issorted(Z)
        perm = sortperm(Z)
        Z = Z[perm]
        θ = θ[perm]
    end

    I = eltype(Z)
    groups = AliasTable{I, UnitRange{I}}[]
    group_sizes = I[]
    start = 1
    while start <= length(Z)
        next = start
        while next <= length(Z) && Z[next] == Z[start]; next += 1 end
        weights = θ[start:next-1]
        push!(groups, AliasTable(weights, start:next-1))
        push!(group_sizes, next-start)
        start = next
    end

    ms = collect(with_replacement_combinations(axes(groups, 1), kmax))
    ms_weights = similar(ms, Float64)
    for (i, m) in enumerate(ms)
        a = number_of_groups_affinity_function(m, 0.5)
        b = multiply_by_cell_count(a, group_sizes, m)
        ms_weights[i] = b
    end
    expected_edges = sum(ms_weights)
    distribution_of_ms = AliasTable(ms_weights, Tuple.(ms))

    DCHSBM_sampler(groups, distribution_of_ms)
end

function multiply_by_cell_count(x, group_sizes, m)
    i0 = firstindex(m)
    m0 = first(m)
    i = i0 + 1
    while true
        if i > lastindex(m) || m[i] != m0
            elements = i-i0
            x *= binomial(group_sizes[m0]+elements-1, elements)
            if i > lastindex(m)
                return x
            end
            i0 = i
            m0 = m[i]
        end
        i += 1
    end
end

"""
    rand(s::DCHSBM_sampler[, edges::Integer])

Draw a hypergraph from the sampler `s` with `edges` edges
"""
function Base.rand(rng::AbstractRNG, s::DCHSBM_sampler)
    map(group -> rand(rng, s.groups[group]), rand(rng, s.ms))
end
