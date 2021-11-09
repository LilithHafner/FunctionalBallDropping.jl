@testset "FBD.used_bits" begin
    @test FBD.used_bits(5) == 3
    @test FBD.used_bits(0) == 0
end

@testset "FBD.kronecker_product" begin
    a = [0 2; 3 4]
    @test FBD.kronecker_power(a, 0) == reshape([1], ())
    @test FBD.kronecker_power(a, 1) === a
    @test FBD.kronecker_power(a, 2) == [0 0 0 4; 0 0 6 8; 0 6 0 8; 9 12 12 16]
end
