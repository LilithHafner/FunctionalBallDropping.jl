@testset "FBD.used_bits" begin
    @test FBD.used_bits(5) == 3
    @test FBD.used_bits(0) == 0
end

@testset "FBD.kronecker_product" begin
    a = [0 2; 3 4]
    p0, p1, p2 = FBD.kronecker_power.([a], 0:2)
    @test p0 == reshape([1], (1,1))
    @test p1 === a
    @test p2 == [0 0 0 4; 0 0 6 8; 0 6 0 8; 9 12 12 16]
    @test reduce(FBD.kronecker_product, [p0, p1, p0, p0, p1]) == p2
end
