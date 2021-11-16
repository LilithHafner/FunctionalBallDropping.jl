using Random
using StatsBase: sample!
using OffsetArrays
#implements https://arxiv.org/pdf/2006.07060.pdf
#strives to be thousands of times faster than https://github.com/manhtuando97/KDD-20-Hypergraph/blob/master/Code/Generator/hyper_preferential_attachment.py

function hyper_pa(degree_distribution, edgesize_distribution, max_edgesize::Integer, nodes::I;
    rng::AbstractRNG=Random.GLOBAL_RNG) where I <: Integer

    edges = [[a,a+I(1)] for a in I(1):I(2):I(max_edgesize-1)]
    edges_by_size = [Vector{I}[] for _ in 1:max_edgesize]
    edges_by_size[2] = copy(edges)

    cum_sum_source = Vector{Int}(undef, max_edgesize)

    binomial_table = [binomial(a,b) for a in 1:max_edgesize, b in 1:max_edgesize-1]

    for n in last(last(edges))+1:nodes
        for _ in 1:rand(degree_distribution)
            new_edgesize = rand(edgesize_distribution)
            new_edge = Vector{I}(undef, new_edgesize)
            new_edge[1] = n

            if new_edgesize > 1
                #binom = 1
                acc = 0
                cum_sum = OffsetVector(view(cum_sum_source, 1:max_edgesize-new_edgesize+2), (new_edgesize-1):max_edgesize) #13%
                for source_edgesize in eachindex(cum_sum)
                    binom = binomial_table[source_edgesize,new_edgesize-1]
                    acc += length(edges_by_size[source_edgesize])*binom
                    cum_sum[source_edgesize] = acc
                    #binom = binom*(source_edgesize+1)÷(source_edgesize-new_edgesize+2)
                end

                total = last(cum_sum)
                if total == 0
                    sample!(rng, 1:(n-1), (@view new_edge[2:end]), replace=false) # sample! mutates its 3rd argument only.
                else
                    key = rand(rng, 1:total)
                    source_edgesize = firstindex(cum_sum)
                    while #=@inbounds=# cum_sum[source_edgesize] < key
                        source_edgesize += 1
                    end

                    #Huzzah! we have a source edgesize!

                    source_edge = rand(rng, edges_by_size[source_edgesize])

                    #Huzzah! and a specific source edge

                    # This sampling takes ~38% of runtime. ~20% of that (~7.5% total) can be
                    # alleviated by passing a workspace vector through. StatsBase doesn't
                    # support that, though.
                    sample!(rng, source_edge, (@view new_edge[2:end]), replace=false) # sample! mutates its 3rd argument only.

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
