struct Categorical{T, I}
    bucket::Vector{T}
    k::I
    edges::I
end
function Categorical(degrees, k; check_args=true)
    sm = sum(degrees)
    edges = sm÷k
    check_args && sm != edges*k && throw(ArgumentError("k must divide sum(degrees), got $k ∤ $sm"))
    bucket = Vector{Int}(undef, sm)
    idx = 1
    for label, degree in enumerate(degrees)
        bucket[i:(i+=degree)-1] .= label
    end
    Categorical(bucket, k, edges)
end

Base.rand(x::Categorical{T, K}) = rand()

function Sampler(::AbstractRNG, cat::Categorical, ::Val{Inf})
