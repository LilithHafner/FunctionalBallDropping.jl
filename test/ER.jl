using Test

N = 100
kmax = 3
edges = 1000
sampler = ER_sampler(N, kmax)

graph = rand(sampler, edges)

for i in graph
    #println(i)
end

@testset "shape" begin
    @test length(graph) == edges
    @test all(length.(graph) .== kmax)
end
