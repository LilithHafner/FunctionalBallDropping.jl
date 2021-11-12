using StatsBase

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
