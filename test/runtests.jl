using FBD
using Test

include("util.jl")

include("dchsbm/model.jl")

include("hyper_pa.jl")

include("kronecker/util.jl")
include("kronecker/model.jl")

#include("../benchmarks/kronecker.jl")
printstyled("Benchmarks are excluded from CI testing because they use plotting which is _slow_ to load :(
Please test manually with:
include(\"benchmarks/kronecker.jl\")\n"; color=Base.warn_color())
