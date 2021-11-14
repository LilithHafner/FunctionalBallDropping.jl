t0 = 1.636823339966585e9
times = []
ks = []
using Plots

function record()
    t1 = time()
    data = open("/Users/x/Downloads/KDD-20-Hypergraph/Code/Generator/od3/DAWN.txt") do f
        read(f, String)
    end

    edge_sizes = [length(split(line, ' ')) for line in split(data, '\n')]
    n = sum(edge_sizes .^ 2)

    k = (t1-t0)/n
    println(k)
    push!(times, t1)
    push!(ks, k)
    #0.00259
end

while true
    record()
    display(scatter(vcat(0,times .- t0), vcat(0, ks), legend=false))
    sleep(10)
end
