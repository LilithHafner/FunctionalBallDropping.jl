using FBD
include("../external/hyperkron.jl")

#external
A,hedges = hyperkron_graph(kron_params(0.99, 0.2, 0.3, 0.05), 5)

#internal
sampler = Kronecker_sampler(rand(5,5,5), 7)
edges = rand(sampler, 100)
