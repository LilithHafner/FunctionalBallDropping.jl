@testset "io" begin

    path = joinpath(@__DIR__, "test_temp.dist")
    try
        open(path, "w") do io
            write(io, "17\n0\n4\n2\n")
        end

        global ps = FBD.read_probabilities(path)

        @test ps == AliasTable([17, 0, 4, 2])
    finally
        rm(path)
    end

    path = joinpath(@__DIR__, "test_temp.graph")
    try
        FBD.write_graph(path, [[5,3,2],[17,33,9],[0,77,-5,12,12,0]])

        open(path) do io
            @test read(io, String) == "5 3 2\n17 33 9\n0 77 -5 12 12 0\n"
        end

    finally
        rm(path)
    end

end
