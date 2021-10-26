using StatsBase: countmap

rand(DCHSBM_sampler([1,1,1,2,2], fill(1, 5), 3, .999999))
rand(DCHSBM_sampler(repeat(1:3, inner=10000000), fill(1, 30000000), 2, .0000000001))

Z = [1,1,1,2,2]
θ = 1:5
kmax = 3
scaling_factor = 10_000
sampler = DCHSBM_sampler(Z, θ, kmax, Float64(scaling_factor))

graph = rand(sampler)

degrees = countmap(reduce(append!, rand(sampler)))

@testset "shape" begin
    @test length(graph) == floor(sampler.expected_edges) || length(graph) == ceil(sampler.expected_edges)
    @test all(length.(graph) .== kmax)
    @test Set(keys(degrees)) == Set(axes(Z, 1))
end

tolerance = 4
max_rtol = ceil(tolerance/sqrt(minimum(values(degrees)))*10_000)/10_000
@testset "degree distribution (rtol ≤ $max_rtol)" begin
    for group = [1:3, 4:5]
        for i in group
            for j in group
                rtol = tolerance/sqrt(min(degrees[i], degrees[j]))
                @test rtol ≤ max_rtol
                @test degrees[i]/degrees[j] ≈ θ[i]/θ[j] rtol=rtol
            end
        end
    end
end
