@testset "hyperPA" begin
    hyper_degrees = AliasTable([2345, 30991, 41226, 29829, 15690, 8247, 3983, 2279, 1669, 1158, 927, 1114, 384, 324, 292, 629])
    degrees = AliasTable([65, 32, 28, 2, 1, 9, 4, 6, 0, 29, 10, 11, 2, 27, 3, 0, 120, 4, 114, 3])
    @test hyper_pa(degrees, hyper_degrees, 16, Int32(1000)) isa Vector{Vector{Int32}}
end
