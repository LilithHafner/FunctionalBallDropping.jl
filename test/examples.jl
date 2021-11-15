@testset "examples" begin
    for size in [500, 100_000]
        for generator in [DCHSBM_sampler, Kronecker_sampler, hyper_pa]
            @test example(generator, size) isa Vector{Vector{Int}}
        end
    end
end
