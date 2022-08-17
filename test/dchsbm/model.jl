using StatsBase: countmap

rand(DCHSBM_sampler(x->1, [1,1,1,2,2], fill(1, 5), 3), 10)
rand(DCHSBM_sampler(x->1/FBD.sorted_unique_count(x)^2, repeat(1:3, inner=10000000), fill(1, 30000000), 2))

Z = [1,1,1,2,2]
θ = 1:5
kmax = 3
m = 1_000_000
intensity = x -> hash(x)/typemax(UInt)+1 # determinitic random ∈ [1,2]
sampler = DCHSBM_sampler(intensity, Z, θ, kmax)

graph = rand(sampler, m)

nodes = []
for e in graph
    append!(nodes, e)
end
degrees = countmap(nodes)

@testset "shape" begin
    @test length(graph) == m
    @test all(length.(graph) .== kmax)
    @test Set(keys(degrees)) == Set(axes(Z, 1))
end

tolerance = 6
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

@testset "large very sparse model" begin
    n = 3_000_000
    kmax = 30

    Z = rand(1:5, n)
    ϑ = rand(n) .+ 1

    Ω = FBD.inverse_power_intensity_function(8)

    sampler = DCHSBM_sampler(Ω, Z, ϑ, kmax);

    x = rand(sampler, 100_000);

    @test sum(length.(x)) == 3_000_000
    @test 2_999_000 ≤ maximum(maximum.(x)) ≤ 3_000_000
end
