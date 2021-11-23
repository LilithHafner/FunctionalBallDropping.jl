@testset "typing" begin
    g = rand(Typing_sampler(5, 10), 7)
    @test g isa Vector{Vector{Vector{Int}}}
    @test length(g) == 7
    @test length(g[3]) == 5
    @test Set(vcat(vcat.(g...)...)) == Set(1:10)

    g = rand(Typing_sampler(3, .4, [.1, .2, .3], ['a', 'b', 'c']), 30)
    @test g isa Vector{Vector{Vector{Char}}}
    @test length(g) == 30
    @test all(length.(g) .== 3)
    @test Set(vcat(vcat.(g...)...)) == Set("abc")
end
