"""
    er(n, m, k)

Sample a hypergraph with `n` nodes and `m` edges of edgesize `≤ k` from an extension of the
Erdős-Rényi graph model to hypergraphs.

Edges are drawn with replacement and weighted according to the number of ways they can be
represented as a list of `k` nodes. For example, when `k = 3` The edge joining nodes 1, 2, 3
has weight 6 with representations

    [1, 2, 3]
    [1, 3, 2]
    [2, 1, 3]
    [2, 3, 1]
    [3, 1, 2]
    [3, 2, 1]

The edge joining nodes 1 and 2 also has weight 6 with representations

    [1, 1, 2]
    [1, 2, 1]
    [2, 1, 1]
    [1, 2, 2]
    [2, 1, 2]
    [2, 2, 1]

While the edge containing only node 3 has weight 1 with the representation

    [3, 3, 3]
"""
er(n, m, k) = rand(1:n, k, m)
