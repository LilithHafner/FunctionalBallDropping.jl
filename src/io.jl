read_probabilities(str::AbstractString, T::Type=Int) = open(io -> read_probabilities(io, T), str)
read_probabilities(io::IOStream, T::Type=Int) = AliasTable(parse.(T, readlines(io)))

write_graph(str::AbstractString, edge_list::Vector{Vector{T}}) where T = open(io -> write_graph(io, edge_list), str, "w")
function write_graph(io::IOStream, edge_list::Vector{Vector{T}}) where T
    for edge in edge_list
        join(io, edge, ' ')
        println(io)
    end
end
