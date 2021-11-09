using FBD
using Test

include("dchsbm/model.jl")
include("kronecker/util.jl")
#include("kronecker/model.jl") these tests are waiting on https://github.com/bramtayl/Unzip.jl/issues/7
printstyled("Some tests must be run manually with: include(\"test/kronecker/model.jl\")\n"; color=Base.warn_color())
