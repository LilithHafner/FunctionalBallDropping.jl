"""
    example(Model, size)

generates an example graph using model `Model` with `hypergraphsize` of approximately `size`.

# Examples

    example(DCHSBM_sampler, 100)

    example(hyper_pa, 1_000_00)

    example(Kronecker_sampler, 10)

    example(Typing_sampler, 10_00)

    example(ER_sampler, 100_00)
"""
function example end

function example(::Type{DCHSBM_sampler}, size)
    Z = vcat([fill(i, ceil(Integer, ∛size*proportion)) for (i,proportion) in enumerate([.4,.1,.03,.2,.2,.07])]...)
    γ = 1.63
    θ = ((γ+1) .* rand(length(Z))) .^ (-γ-1)
    intensity = inverse_power_intensity_function(8)

    sampler = DCHSBM_sampler(intensity, Z, θ, 4)

    rand(sampler, size ÷ 4)
end

function example(::typeof(hyper_pa), size)
    degree_distribution = AliasTable([1,415,267,152,140,101,93,66,61,47,53,36,44,30,36,32,29,25,31,21,
    16,16,23,21,16,15,18,19,12,20,12,5,12,19,13,11,13,12,6,9,10,11,4,15,5,6,6,7,4,7,7,6,2,6,8,6,5,1,8,
    10,8,3,1,7,3,4,4,3,5,5,4,3,4,4,5,3,2,3,7,5,4,3,2,3,3,2,5,4,1,2,4,4,3,4,1,2,2,2,4,3,1,5,6,1,4,1,4,2,
    1,5,4,1,2,2,2,2,2,2,7,1,1,2,2,2,5,1,1,2,4,3,2,3,2,1,2,1,2,1,2,1,2,2,1,1,3,2,2,1,1,2,2,1,3,3,3,1,2,
    4,1,1,1,1,1,2,1,2,1,1,4,1,1,1,1,1,1,1,1,2,4,1,2,2,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,2,1,2,
    1,2,1,2,1,2,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1], cumsum([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,2,1,1,1,2,1,1,1,1,1,1,1,2,1,1,2,2,2,4,
    1,1,1,1,2,1,1,1,1,1,1,1,2,1,2,1,2,3,1,2,2,1,1,1,1,1,1,4,2,3,1,2,1,2,1,1,1,1,1,1,3,1,1,4,4,1,2,3,1,
    1,1,5,1,1,1,3,1,2,2,2,1,1,1,1,1,2,1,1,2,1,1,1,2,5,1,3,4,6,2,2,3,1,1,9,1,1,4,4,6,1,2,3,4,3,2,11,2,3,
    6,3,5,3,2,1,3,13,19,3,2,2,5,13,5,5,4,4,12,12,7,3,2,4,8,2,1,1,1,2,14,1,21,1,11,4,3,4,4,7,10,18,27,
    14,10,38,10,1,4,2,4,15,9,9,1,1,2,15,20,13,10,46,25,23,53,9,12,97,4,51,53,49,41,7,45,11,7,84,16,13,
    1,26,104,71,31,159]))

    edgesize_distribution = AliasTable([2345, 30991, 41226, 29829, 15690, 8247, 3983, 2279,
    1669, 1158, 927, 1114, 384, 324, 292, 629])

    max_edgesize = length(edgesize_distribution.accept)

    nodes = size ÷ 222 + 18

    hyper_pa(degree_distribution, edgesize_distribution, max_edgesize, nodes)
end

function example(::Type{Kronecker_sampler}, size)
    # parameters copied from https://www.cs.purdue.edu/homes/dgleich/codes/hyperkron/
    initializer = [0.99; 0.2;; 0.2; 0.3;;; 0.2; 0.3;; 0.3; 0.05]
    @static if VERSION < v"1.7"
        initializer = reshape(initializer, (2,2,2))
    end

    edges = size ÷ 3

    sampler = Kronecker_sampler(initializer, max(1, floor(Integer, log(size))), space=edges÷100)

    rand(sampler, edges)
end

function example(::Type{Typing_sampler}, size)

    sampler = Typing_sampler(3, .4, [.1, .2, .3], ['a', 'b', 'c'])

    rand(sampler, size ÷ 3)

end

function example(::typeof(er), size)

    s = round(Integer, ∛size)

    er(size, s^2, s)

end

hypergraphsize(graph) = sum(length.(graph))

function MEPS(;generators = [DCHSBM_sampler, Kronecker_sampler, hyper_pa, Typing_sampler, er], size=100_000, trials=5)
    [begin
        speed = median(begin
            time = @elapsed graph = example(gen, size)
            sum(length.(graph))/time
        end for i in 1:trials)
        gen => round(Integer, speed/10^6)
    end for gen in generators]
end
