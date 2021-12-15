using Test
using StatsBase

@testset "shape" begin
    s = Kronecker_sampler([1,2,3,4], 2)
    e = rand(s)
    @test typeof(e) == Tuple{Int}
    @test length(e) == 1
    g = rand(s, 7)
    @test eltype(g) == typeof(e)
    @test axes(first(g)) == axes(e)
    @test typeof(g) == Vector{Tuple{Int}}
    @test size(g) == (7,)

    s = Kronecker_sampler(rand(2,3,1), 2)
    e = rand(s)
    @test typeof(e) == NTuple{3, Int}
    @test length(e) == 3
    g = rand(s, 3, 3)
    @test eltype(g) == typeof(e)
    @test axes(first(g)) == axes(e)
    @test typeof(g) == Matrix{NTuple{3, Int}}
    @test size(g) == (3, 3)
end


@testset "hit all" begin
    for (vals, p) in [((4,1,2), 3), ((3,3), 1), ((1,1), 12)]
        n = prod(vals)^p
        m = Int(floor(n*log(n)*3+100))
        for space in [0, m]
            s = Kronecker_sampler(ones(vals...), p; space=space)

            g = rand(s, m)

            @test length(g) == m
            @test length(countmap(g)) == n

            if length(countmap(g)) != n
                println(vals, " ", p, " ", space)
            end
        end
    end
end
