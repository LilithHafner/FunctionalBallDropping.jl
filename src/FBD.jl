module FBD

export example,
    DCHSBM_sampler, Kronecker_sampler, hyper_pa, Typing_sampler, ER_sampler,
    AliasTable

include("alias_table.jl")
include("io.jl")

include("dchsbm/number_of_groups_affinity_function.jl")
include("dchsbm/model.jl")

include("kronecker/util.jl")
include("kronecker/model.jl")

include("hyper_pa.jl")

include("typing.jl")

include("ER.jl")

include("examples.jl")

end
