using Distributions
using Unzip: unzip
using Random
used_bits(x::Union{Signed, Unsigned}) = sizeof(x)*8 - leading_zeros(x)

#=function kronecker(initializer::AbstractArray, power::Integer, edges::Integer, T::Type=Int)
    is, ps = unzip(pairs(initializer))
    is = Tuple.(vec(is))
    dist = Categorical(vec(ps) ./ sum(ps))
    min = minimum.(unzip(is))
    map!(i -> i.-min, is, is)
    bits = maximum(maximum(used_bits.(i)) for i in is)
    k = length(axes(initializer))
    [begin
        edge = fill(zero(T), k)
        for i in 0:(power-1)
            for (j,v) in enumerate(is[rand(dist)])
                edge[j] |= v << (i * bits)
            end
        end
        edge
    end for _ in 1:edges]
end=#

struct Kronecker_sampler{T} <: Random.Sampler{Vector{T}}
    k::Integer
    power::Integer
    is::AbstractVector
    dist::Sampleable{Univariate, Discrete}
    bits::Integer
end

"""
    Kronecker_sampler(initializer, power, T=Int)

Create an efficient edge sampler whose probability distribution follows the specified
kroneker model.

Draw a hypergraph from the sampler with `rand(sampler, edges)`.
"""
function Kronecker_sampler(initializer::AbstractArray, power::Integer, T::Type=Int, normalize=true)

    println("fail1")
    unzip([(1,), (2,), (3,), (4,)])
    println("fail2")

    println(pairs(initializer))
    unzip(pairs([1,2,3,4]))
    println(initializer)
    println(initializer == [1,2,3,4])
    println(pairs(initializer) == pairs([1,2,3,4]))
    println(typeof(pairs(initializer)) == typeof(pairs([1,2,3,4])))
    println("X1")
    unzip(pairs([1,2,3,4]))
    println("X2")
    unzip(pairs(initializer))
    println("X3")
    println("B", "C")
    println(unzip(pairs(initializer)))
    println("HOW?")
    is, ps = unzip(pairs(initializer))
    println("!")
    is = Tuple.(vec(is))
    println("!2")
    dist = Categorical(vec(ps) ./ sum(ps))
    println("!2.5")
    if normalize
        println("IS: ", is)
        println(is == [(1,), (2,), (3,), (4,)])


        min = minimum.(unzip(is))
        println("fail3")
        map!(i -> i.-min, is, is)
    end
    println("!2.6")
    bits = maximum(maximum(used_bits.(i)) for i in is)
    println("!2.7")
    k = length(axes(initializer))
    println("!3")
    Kronecker_sampler{T}(k, power, is, dist, bits)
end

"""
    rand(s::Kronecker_sampler)
    rand(s::Kronecker_sampler, e::Integer)

Draw an edge or a hypergraph with `e` edges from the sampler `s`.
"""
function Base.rand(rng::AbstractRNG, s::Kronecker_sampler{T}) where T
    edge = fill(zero(T), s.k)
    for i in 0:(s.power-1)
        for (j,v) in enumerate(s.is[rand(rng, s.dist)])
            edge[j] |= v << (i * s.bits)
        end
    end
    edge
end
