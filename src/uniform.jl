uniform(nodes, edge_size) = Independent(Random.Sampler(Random.default_rng(), Base.oneto(nodes)), edge_size)
