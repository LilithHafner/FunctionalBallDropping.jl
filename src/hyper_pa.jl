using Random
using OffsetArrays
#implements https://arxiv.org/pdf/2006.07060.pdf
#strives to be thousands of times faster than https://github.com/manhtuando97/KDD-20-Hypergraph/blob/master/Code/Generator/hyper_preferential_attachment.py

function hyper_pa(degree_distribution, edgesize_distribution, max_edgesize::Integer, nodes::I;
    rng::AbstractRNG=Random.default_rng()) where I <: Integer

    bitvector = BitVector(undef, max_edgesize)
    edges = [[a,a+I(1)] for a in I(1):I(2):I(max_edgesize-1)]
    edges_by_size = [Vector{I}[] for _ in 1:max_edgesize]
    edges_by_size[2] = copy(edges)

    for n in last(last(edges))+1:nodes
        for _ in 1:rand(degree_distribution)
            new_edgesize = rand(edgesize_distribution)

            if new_edgesize == 1
                new_edge = [n]
            else
                binom, acc = 1, 0
                cum_sum = OffsetVector{Int}(undef, (new_edgesize-1):max_edgesize)
                for source_edgesize in eachindex(cum_sum)
                    acc += length(edges_by_size[source_edgesize])*binom
                    cum_sum[source_edgesize] = acc
                    binom = binom*(source_edgesize+1)÷(source_edgesize-new_edgesize+2)
                end

                total = last(cum_sum)
                if total == 0
                    new_edge = pick_rest(rng, n, 1:(n-1), new_edgesize-1, temp=bitvector)
                else
                    key = rand(rng, 1:total)
                    source_edgesize = firstindex(cum_sum)
                    while #=@inbounds=# cum_sum[source_edgesize] < key
                        source_edgesize += 1
                    end

                    #Huzzah! we have a source edgesize!

                    source_edge = rand(rng, edges_by_size[source_edgesize])

                    #Huzzah! and a specific source edge

                    new_edge = pick_rest(rng, n, source_edge, new_edgesize-1, temp=bitvector)

                    #Huzzah! and an actual edge to use
                end
            end

            push!(edges, new_edge)
            @assert length(new_edge) == new_edgesize
            push!(edges_by_size[new_edgesize], new_edge)
        end
    end

    edges
end

function pick_rest(rng, fst, from, number_to_pick; temp)
    if length(temp) < length(from)
        resize!(temp, length(from))
    end
    out = Vector{typeof(fst)}(undef, 1+number_to_pick)
    out[1] = fst
    bv = @view temp[eachindex(from)]
    use = if length(from)-number_to_pick < number_to_pick
        (!).(set_true(rng, bv, length(from)-number_to_pick))
    else
        set_true(rng, bv, number_to_pick)
    end
    i = 2
    for (f, v) in zip(from, use)
        if v
            out[i] = f
            i += 1
        end
    end
    out
end
function set_true(rng, bv, number_to_pick)
    bv .= false
    for _ in 1:number_to_pick
        i = 0
        while true
             i = rand(rng, eachindex(bv))
             bv[i] || break
        end
        bv[i] = true
    end
    bv
end


function params(name, nodes, path)
    edgesize_distribution = read_probabilities(path * "Code/Generator/size distribution/" * name * " size distribution.txt")
    degree_distribution = read_probabilities(path * "Code/Generator/simplex per node/" * name * "-simplices-per-node-distribution.txt")
    max_edgesize = findlast(edgesize_distribution.accept .> 0)
    degree_distribution, edgesize_distribution, max_edgesize, nodes
end
function main(name, nodes, path="/Users/x/Downloads/KDD-20-Hypergraph/")
    ps = params(name, nodes, path)
    @time graph = hyper_pa(ps...)
    write_graph(path * "Code/Generator/julia_out/" * name * ".txt", graph)
    graph
end

function compute_time(name="DAWN", nodes=3029, path="/Users/x/Downloads/KDD-20-Hypergraph/")
    ps = params(name, nodes, path)
    m = @benchmark graph = hyper_pa($ps...)
    display(m)
    time(median(m)/1e9)
end


@elapsed main("DAWN", 3029)

#= Compare to:
x@X Generator % time python3 hyper_preferential_attachment.py --name=DAWN --file_name=DAWN --num_nodes=3029 --simplex_per_node_directory='simplex per node' --size_distribution_directory='size distribution' --output_directory=output_directory
done with DAWN
python3 hyper_preferential_attachment.py --name=DAWN --file_name=DAWN      22469.39s user 1842.45s system 93% cpu 7:14:08.42 total
x@X Generator %
=#
