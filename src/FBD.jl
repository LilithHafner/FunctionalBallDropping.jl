module FBD

export example, MEPS,
    DCHSBM_sampler, Kronecker_sampler, Typing_sampler, ER_sampler,
    hyper_pa, er, 
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
include("simple_er.jl")

include("examples.jl")

end
