using Combinatorics: with_replacement_combinations
using Distributions

"""
The ER sampler consists of:
    - N, Int, the node count
    - kmax, Int, the maximum hyperedge size
    - expected_edges, Real
    - one_size, Bool, whether all edges have size kmax, or not
In the ER model, all edges have the same probability of placement.
The expected_edges was calculated by taking the number of non-decreasing edges
    using binomial((N+kmax-1), kmax) and multiplying by the probability of each
    edge P.
We use the 3 parameter function ER_sampler below to generate the sampler.
"""
struct ER_sampler{I <: Integer, R <: Real}
    N::I
    kmax::I
    expected_edges::R
    one_size::Bool # whether all edges have the same size (kmax)
end

"""
Generate the ER_sampler
3 parameters:
- N, Int, the node count
- kmax, Int, the maximum hyperedge size
- P, Real, the probability for each edge
"""
function ER_sampler(N::Integer, kmax::Integer, P::Real)
    unique_edges = binomial((N+kmax-1), kmax) #the number of unique non-decreasing edges
    expected_edges = unique_edges * P
    ER_sampler(N, kmax, expected_edges, true)
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

function Base.rand(s::ER_sampler; edges::Integer=rand_round(s.expected_edges))
    [[rand(1:s.N) for node in s.kmax] for _ in 1:edges]
end
