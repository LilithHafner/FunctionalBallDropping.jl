using FBD, Plots, Unzip
include("../external/hyperkron.jl")

function time_both(power)
    #external
    a = @elapsed A,hedges = hyperkron_graph(kron_params(0.99, 0.2, 0.3, 0.05), power)

    edge_count = length(hedges[1])

    #internal
    b = @elapsed sampler = Kronecker_sampler(kron_params(0.99, 0.2, 0.3, 0.05), power)
    c = @elapsed edges = rand(sampler, edge_count)

    edge_count,a,b+c,b,c
end

data = unzip((power, minimum.(unzip(time_both(power) for trial in 1:5))...) for power in 1:12)
plot(data[1], log10.(data[2]), label="edges (log10)", legend=(.15,.95), title="runtime vs k")
offset = log(minimum(minimum.(data)))
plot!(data[1], data[3] ./ data[2] * 1e6, label="external (μs per edge)")
plot!(data[1], data[4] ./ data[2] * 1e6, label="internal (μs per edge)")
plot!(data[1], data[5] ./ data[2] * 1e6, label="create sampler (μs per edge)")
plot!(data[1], data[6] ./ data[2] * 1e6, label="sample (μs per edge)")
plot!(data[1], data[4]./data[3], label="internal/external")

scatter(data[2], data[3], label="external", legend=(.15,.95), title="runtime vs edges")
scatter!(data[2], data[4], label="internal")
