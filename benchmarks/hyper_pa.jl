using BenchmarkTools

include("../external/load_hyper_pa.jl")
load_hyper_pa()

function path()
    joinpath(@__DIR__, "..", "external", "hyper_pa")
end


function params(name, nodes)
    edgesize_distribution = read_probabilities(joinpath(path(), "size distribution", name * " size distribution.txt"))
    degree_distribution = read_probabilities(joinpath(path(), "simplex per node", name * "-simplices-per-node-distribution.txt"))
    max_edgesize = findlast(edgesize_distribution.accept .> 0)
    degree_distribution, edgesize_distribution, max_edgesize, nodes
end
function with_io(name="DAWN", nodes=3029)
    ps = params(name, nodes)
    @time graph = hyper_pa(ps...)
    mkpath(joinpath(path(), "julia_out"))
    write_graph(joinpath(path(), "julia_out", name * ".txt"), graph)
    graph
end

function compute_time(name="DAWN", nodes=3029)
    ps = params(name, nodes)
    m = @benchmark graph = hyper_pa($ps...)
    display(m)
    time(median(m))/1e9
end

function profile(name="DAWN", nodes=3029)
    ps = params(name, nodes)
    Juno.@profiler for i in 1:20; graph = hyper_pa(ps...); end
end

function external(nodes=200)
    printstyled("expected runtime on the order of $(round(Integer, (nodes/200)^2)) minutes", color=Base.warn_color())
    @elapsed cd(path()) do
        run(`python3 hyper_preferential_attachment.py --name=DAWN --file_name=DAWN --num_nodes=$nodes --simplex_per_node_directory='simplex per node' --size_distribution_directory='size distribution' --output_directory=output_directory`)
    end
end

#println("", compute_time())
#println("", external())

#= at default size:
x@X Generator % time python3 hyper_preferential_attachment.py --name=DAWN --file_name=DAWN --num_nodes=3029 --simplex_per_node_directory='simplex per node' --size_distribution_directory='size distribution' --output_directory=output_directory
done with DAWN
python3 hyper_preferential_attachment.py --name=DAWN --file_name=DAWN      22469.39s user 1842.45s system 93% cpu 7:14:08.42 total
x@X Generator %
=#
