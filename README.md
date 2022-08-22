# Functional Ball Dropping

## fast hypergraph generation

[![Build Status](https://github.com/LilithHafner/FunctionalBallDropping.jl/workflows/CI/badge.svg)](https://github.com/LilithHafner/FunctionalBallDropping.jl/actions)
[![Coverage](https://codecov.io/gh/LilithHafner/FunctionalBallDropping.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/FunctionalBallDropping.jl)

Uses the functional ball dropping technique to provide efficient generators for a variety of hypergraph (henceforth graph) models inlcuding
- Hyper preferential attachment (Do, Yoon, Hooi, & Shin)
- Degree corrected hyper stochastic block (Chodrow, Veldt, & Benson)
- Hyper Kronecker product (Eikmeier, Ramani, & Gleich)
- Hyper typing model (Chang & Chen)
- Uniform homogonous (Erdős & Rényi)

In all cases, maximum edge size (also known as hyperdegree) can vary from 1–30. In many cases it can range all the way up to 10<sup>5</sup> or even 10<sup>10</sup> depending on the model and host machine. This package is capable of producing ordinary graphs by setting maximum hpyerdegree to 2.

### Usage

```jl
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

Medium and large graphs are produced at a rate of 3 million to 150 million edges in the bipartite projection per second for all models on a single threaded 1.6 Ghz machine. The number of clock cycles per bipartite edge for each model at a variety of scales is approximately as follows:

| Model \ Size | 10 | 10<sup>2</sup> | 10<sup>3</sup> | 10<sup>4</sup> | 10<sup>5</sup> | 10<sup>6</sup> | 10<sup>7</sup> |
|-|----|----------------|----------------|----------------|----------------|----------------|----------------|
| Preferential Attachment | 203 | 208 | 103 | 77 | 88 | 141 | 223 |
| Degree Corrected Stochastic Block | 25750 | 2137 | 281 | 85 | 52 | 39 | 29 |
| Kronecker | 196 | 54 | 58 | 85 | 71 | 54 | 45 |
| Typing | 305 | 187 | 188 | 187 | 187 | 252 | 448 |
| Uniform | 28 | 9 | 9 | 14 | 14 | 15 | 11 |

A forthcoming paper utilizing results from [FBDCompare.jl](https://github.com/LilithHafner/FBDCompare.jl) compares the performance of this package to the previous state of the art.
