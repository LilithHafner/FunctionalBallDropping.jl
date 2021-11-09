using Distributions
using Unzip: unzip
using Random

struct Kronecker_sampler{T} <: Random.Sampler{Vector{T}}
    k::Integer
    bits::Integer
    power::Integer
    primary::Tuple{<:AbstractVector, <:Sampleable{Univariate, Discrete}}
    remainder::Union{Nothing, Tuple{<:AbstractVector, <:Sampleable{Univariate, Discrete}}}
end

"""
    Kronecker_sampler(initializer, power, T=Int)

Create an efficient edge sampler whose probability distribution follows the specified
kroneker model.

Draw a hypergraph from the sampler with `rand(sampler, edges)`.
"""
function Kronecker_sampler(initializer::AbstractArray, power::Integer;
    T::Type=Int, normalize=true, size=1,
    outer_power = cld(power, max(1, min(power, Int(log(max(1,size)) ÷ log(max(2,length(initializer))))))))

    inner_power = fld(power, outer_power)
    rem = power - inner_power*outer_power

    primary = k_sampler(kronecker_power(initializer, inner_power), normalize)
    remainder = rem == 0 ? nothing : k_sampler(kronecker_power(initializer, rem), normalize)

    bits = maximum(maximum(used_bits.(i)) for i in first(primary))

    k = length(axes(initializer))
    Kronecker_sampler{T}(k, bits, outer_power, primary, remainder)
end

function k_sampler(initializer, normalize)
    is = Tuple.(vec(eachindex(IndexCartesian(), initializer)))
    dist = Categorical(vec(initializer) ./ sum(initializer))
    if normalize
        mn = minimum.(unzip(is))
        map!(i -> i .- mn, is, is)
    end
    is, dist
end


"""
    rand(s::Kronecker_sampler)
    rand(s::Kronecker_sampler, e::Integer)

Draw an edge or a hypergraph with `e` edges from the sampler `s`.
"""
function Base.rand(rng::AbstractRNG, s::Kronecker_sampler{T}) where T
    edge = fill(zero(T), s.k)
    for i in 0:(s.power-1);    k_draw!(rng, edge,       i*s.bits, s.primary);   end
    if s.remainder != nothing; k_draw!(rng, edge, s.power*s.bits, s.remainder); end
    edge
end

function k_draw!(rng, edge, offset, source)
    for (i,v) in enumerate(first(source)[rand(rng, last(source))])
        edge[i] |= v << offset
    end
end
