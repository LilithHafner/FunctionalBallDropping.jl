using Test

N = 100
kmax = 3
P = 0.001
sampler = ER_sampler(N, kmax, P)

graph = rand(sampler)

for i in graph
    #println(i)
end

@testset "shape" begin
    @test length(graph) == floor(sampler.expected_edges) || length(graph) == ceil(sampler.expected_edges)
    @test all(length.(graph) .== kmax)
    @test sampler.expected_edges == (binomial((N+kmax-1), kmax) * P)
end
