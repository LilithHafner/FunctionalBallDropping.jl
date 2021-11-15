using BenchmarkTools, FBD, Plots, Unzip
include("../external/hyperkron.jl")

function time_both(power)
    #external
    a = @elapsed A,hedges = hyperkron_graph(kron_params(0.99, 0.2, 0.3, 0.05), power)

    edge_count = length(hedges[1])#Int(floor(sum(kron_params(0.99, 0.2, 0.3, 0.05))^power))

    #internal
    b = @elapsed sampler = Kronecker_sampler(kron_params(0.99, 0.2, 0.3, 0.05), power; space=1)
    c = @elapsed edges = rand(sampler, edge_count)

    @assert length(edges) == edge_count

    #internal 2
    d = @elapsed sampler = Kronecker_sampler(kron_params(0.99, 0.2, 0.3, 0.05), power; space=edge_count÷100)
    e = @elapsed edges = rand(sampler, edge_count)

    @assert length(edges) == edge_count

    edge_count,a,b+c,b,c,d+e,d,e
end

data = unzip((power, minimum.(unzip(time_both(power) for trial in 1:3))...) for power in 1:15)
plot(data[1], log10.(data[2]), label="edges (log10)", legend=(.15,.95), style=:dash, color=:black, title="runtime vs k")
plot!(data[1], data[3] ./ data[2] * 1e6, label="external (μs per edge)")
plot!(data[1], data[4] ./ data[2] * 1e6, label="internal (μs per edge)")
plot!(data[1], data[5] ./ data[2] * 1e6, label="create sampler (μs per edge)")
plot!(data[1], data[6] ./ data[2] * 1e6, label="sample (μs per edge)")
plot!(data[1], data[4+3] ./ data[2] * 1e6, label="allocating internal (μs per edge)")
plot!(data[1], data[5+3] ./ data[2] * 1e6, label="allocating create sampler (μs per edge)")
plot!(data[1], data[6+3] ./ data[2] * 1e6, label="allocating sample (μs per edge)")
#display(plot!(data[1], data[6] ./ data[6+3], style=:dot, color=:grey, label="ratio: small/allocating"))
display(plot!(data[1], data[3] ./ data[4], style=:dot, color=:grey, label="ratio: external/internal"))

plot(data[2], data[3], label="external", marker=:cirlce, legend=(.15,.95), title="runtime vs edges")
plot!(data[2], data[4], label="internal", marker=:cirlce)
display(plot!(data[2], data[4+3], label="allocating internal", marker=:cirlce))
