# Functional Ball Dropping

## fast hypergraph generation

[![Build Status](https://github.com/LilithHafner/FunctionalBallDropping.jl/workflows/CI/badge.svg)](https://github.com/LilithHafner/FunctionalBallDropping.jl/actions)
[![Coverage](https://codecov.io/gh/LilithHafner/FunctionalBallDropping.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/FunctionalBallDropping.jl)

Implements efficient generators for a variety of hypergraph (henceforth graph) models inlcuding
- Hyper preferential attachment (Do, Yoon, Hooi, & Shin)
- Degree corrected hyper stochastic block (Chodrow, Veldt, & Benson)
- Hyper Kronecker product (Eikmeier, Ramani, & Gleich)
- Hyper typing model (Chang & Chen)
- Uniform homogonous (Erdős & Rényi)

In all cases, maximum edge size (also known as hyperdegree) can vary from 1–30. In many cases it can range all the way up to 10<sup>5</sup> or even 10<sup>10</sup> depending on the model and host machine. This package is capable of producing ordinary graphs by setting maximum hpyerdegree to 2.

### Usage

```jl
]add https://github.com/LilithHafner/FunctionalBallDropping.jl
using FunctionalBallDropping
graph = example(Kronecker_sampler, 30)
```

```jl
10-element Vector{Tuple{Int64, Int64, Int64}}:
 (6, 0, 2)
 (3, 0, 0)
 (0, 5, 5)
 (1, 2, 2)
 (4, 2, 1)
 (0, 4, 0)
 (2, 6, 4)
 (1, 4, 5)
 (5, 7, 6)
 (0, 2, 0)
```

See [`src/examples.jl`](src/examples.jl) for examples!

### Performance

Graphs are produced at a rate of 10<sup>7</sup>–10<sup>8</sup> edges in the bipartite projection per second for all models on a single threaded 1.6 Ghz machine. For large graphs, this system is capable of producing gaphs in 8-300 clock cycles per entry, depending on the model.
