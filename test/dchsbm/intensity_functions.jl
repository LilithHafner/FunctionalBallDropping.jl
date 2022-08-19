@testset "inverse_power_intensity_function" begin
    f = FunctionalBallDropping.inverse_power_intensity_function(1)
    @test f([1,2,3]) == 1/3
    @test f([1,2,3,4]) == 1/4
    @test f([1,2,2,3]) == 1/3
    @test f([1,2,2,2]) == 1/2
    @test f([1,4]) == 1/2
    @test f([1,1,4]) == 1/2
    @test f([:blue,:blue,:red]) == 1/2
    @test f([1]) == 1
    @test f([]) == Inf

    f = FunctionalBallDropping.inverse_power_intensity_function(1.7)
    @test f([1, 2, 2, 4, 5, 5, 6, 6, 7, 8]) == 1/7^1.7 ≈ 0.03658755025553056
end

@testset "all_or_nothing_intensity_function" begin
    f = FunctionalBallDropping.all_or_nothing_intensity_function(10, .1)
    @test f([1,2]) == .1
    @test f([2,2]) == 10

    f = FunctionalBallDropping.all_or_nothing_intensity_function(17, 29)
    @test f([1,2,3]) == 29
    @test f([1]) == 17
    @test f(14) == 17
    @test f([]) == 17
    @test f([1,1,1]) == 17
    @test f((1,1,1)) == 17
    @test f((1,1,3)) == 29
    @test f([1,1,1.0]) == 17
    @test f([1,2,1]) == 29
    @test f([1,:🦹,1]) == 29
end
