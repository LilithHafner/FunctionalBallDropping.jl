module FBD

export DCHSBM_sampler, Kronecker_sampler

include("../external/dchsbm/affinity_function.jl")
include("dchsbm/model.jl")

include("kronecker.jl")

end
