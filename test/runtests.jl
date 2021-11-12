using FBD
using Test

include("util.jl")

include("dchsbm/model.jl")
include("kronecker/util.jl")
#include("kronecker/model.jl") these tests are waiting on https://github.com/bramtayl/Unzip.jl/issues/7
printstyled("Kronecker model tests must be run manually with: include(\"test/kronecker/model.jl\")\n\n"; color=Base.warn_color())

#include("../benchmarks/kronecker.jl")
printstyled("Benchmarks are excluded from CI testing because they use plotting which is _slow_ to load :(
and because they have dependencies which fail in the test harness. Please test manually with:
include(\"benchmarks/kronecker.jl\")\n"; color=Base.warn_color())
