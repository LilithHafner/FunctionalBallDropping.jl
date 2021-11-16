@testset "examples" begin
    for size in [3, 792, 40_000]
        for generator in [DCHSBM_sampler, Kronecker_sampler, hyper_pa]
            @test example(generator, size) isa Vector{Vector{Int}}
        end
    end
    speeds = FBD.MBPS(size=10_000, trials=6)
    @test length(speeds) == 3
    display(speeds)
    @test all(last.(speeds) .>= 3)
end
