function load_hyper_pa(redo=false)
    if !redo && isdir(joinpath(@__DIR__, "hyper_pa"))
        return
    end

    println("downloading hyper_pa source files from
    https://github.com/manhtuando97/KDD-20-Hypergraph/tree/8cf291784025aaf4fbe618e5d9f6934a19d75b61/Code/Generator")
    cd(@__DIR__) do
        run(`git clone https://github.com/manhtuando97/KDD-20-Hypergraph delete_me`)
        cd("delete_me")
        run(`git reset --hard 8cf291784025aaf4fbe618e5d9f6934a19d75b61`)
        cd("..")
        run(`rm -rf hyper_pa`)
        run(`cp -r $(joinpath("delete_me", "Code", "Generator")) hyper_pa`)
        run(`rm -rf delete_me`)
        mkdir(joinpath("hyper_pa", "output_directory"))
    end
end
