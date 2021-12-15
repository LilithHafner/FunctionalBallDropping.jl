@testset "examples" begin
    for size in [3, 792, 40_000]
        for generator in [DCHSBM_sampler, hyper_pa]
            @test example(generator, size) isa Vector{Vector{Int}}
        end
        for generator in [Kronecker_sampler]
            @test example(generator, size) isa Vector{<:NTuple}
        end
    end
    println("\nMB per second")
    display(FBD.MBPS(size=10_000, trials=6))
    println("\n\nMillions of entries per second")
    display(MEPS(size=10_000, trials=6))
    println("\n")
end
