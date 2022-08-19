using StatsBase

@testset "OneToInf" begin
    x = FunctionalBallDropping.OneToInf()
    y = FunctionalBallDropping.OneToInf()
    @test x == y
    @test x === y
    @test length(x) > 10^10
    @test size(x) > (10^10,)
    @test all(x[z] === z for z in rand(Int, 100))
    @test_broken all(x[z] === z for z in rand(UInt128, 100))
    z = rand(UInt32, 100)
    @test x[z] == z
    z = rand(Int, 100)
    @test_broken x[z] == z
    z = rand(UInt, 100)
    @test_broken x[z] == z
    e, i = iterate(x)
    @test e == 1
    e, i = iterate(x, i)
    @test e == 2
    e, i = iterate(x, i)
    @test e == 3
    @test_throws (VERSION < v"1.8" ? ErrorException : ArgumentError) collect(x)
    @test string(x) == "OneToInf()"
    @test Base.IteratorSize(x) isa Base.IsInfinite
end

@testset "alias table" begin #TODO use general integer atol.
    n = 200_000
    weights = [2,3,100,12.5]

    data = rand(AliasTable(weights), n)
    @test length(data) == n
    @test Set(data) == Set(1:4)
    map = countmap(data)
    for (value, weight) in enumerate(weights)
        ratio = map[value] / weight * sum(weights) / n
        @test abs(ratio - 1) < .15
    end

    support = [1,2,3,"apple"]
    data = rand(AliasTable(weights, support), n)
    @test length(data) == n
    @test Set(data) == Set(support)
    map = countmap(data)
    for (value, weight) in zip(support, weights)
        ratio = map[value] / weight * sum(weights) / n
        @test abs(ratio - 1) < .15
    end
end
