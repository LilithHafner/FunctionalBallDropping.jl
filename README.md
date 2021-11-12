# Functional Ball Dropping

## a unification of (clustered) (hyper)-graph generation

[![Build Status](https://github.com/LilithHafner/FBD.jl/workflows/CI/badge.svg)](https://github.com/LilithHafner/FBD.jl/actions)
[![Coverage](https://codecov.io/gh/LilithHafner/FBD.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/FBD.jl)

Usage:

```jl
]add https://github.com/LilithHafner/FBD.jl
using FBD.jl

Z = [1,1,1,2,2]
θ = 1:5
kmax = 3
scaling_factor = 1
sampler = DCHSBM_sampler(Z, θ, kmax, Float64(scaling_factor))

graph = rand(sampler)

display(graph)
```

```jl
6-element Vector{Vector{Int64}}:
 [1, 3, 3]
 [2, 2, 2]
 [2, 2, 2]
 [3, 3, 3]
 [3, 2, 2]
 [3, 1, 2]
```
