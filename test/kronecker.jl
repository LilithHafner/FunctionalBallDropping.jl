using Test

@testset "FBD.used_bits" begin
    @test FBD.used_bits(5) == 3
    @test FBD.used_bits(0) == 0
end

#@testset "shape" begin

    s = Kronecker_sampler([1,2,3,4], 2)
    e = rand(s)
    @test typeof(e) == Vector{Int}
    @test size(e) == (1,)
    g = rand(s, 7)
    @test eltype(g) == typeof(e)
    @test axes(first(g)) == axes(e)
    @test typeof(g) == Vector{Vector{Int}}
    @test size(g) == (7,)

    s = Kronecker_sampler(rand(2,3,1), 2)
    e = rand(s)
    @test typeof(e) == Vector{Int}
    @test size(e) == (3,)
    g = rand(s, 3, 3)
    @test eltype(g) == typeof(e)
    @test axes(first(g)) == axes(e)
    @test typeof(g) == Matrix{Vector{Int}}
    @test size(g) == (3, 3)
#end
