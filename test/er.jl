using Test

N = 100
kmax = 3
edges = 1000

graph = er(N, edges, kmax)

@testset "er" begin
    @test size(graph) == (3, 1000)
    @test abs(mean(graph) - 50.5) < 5
    @test extrema(graph) == (1, 100)
    @test unique!(sort!(vec(graph))) == collect(1:100)
end
