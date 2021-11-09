used_bits(x::Union{Signed, Unsigned}) = sizeof(x)*8 - leading_zeros(x)

"""
    kronecker_product(a, b)

Returns `a ⊗ b`, see: https://en.wikipedia.org/wiki/Kronecker_product.
"""
function kronecker_product(a::T, b::T) where T <: AbstractArray
    out = similar(a, size(a) .* size(b))
    for i in eachindex(IndexCartesian(), a)
        for j in eachindex(IndexCartesian(), b)
            out[CartesianIndex((Tuple(i) .- 1) .* size(b) .+ Tuple(j))] = a[i]*b[j]
        end
    end
    out
end

"""
    kronecker_power(a, power)

returns `a` kroneker producted with itself `power` times. Does not copy when power == 1.

See also: [`kronecker_product`](@ref)
"""
function kronecker_power(a::AbstractArray, power::Integer)
    if power < 0
        throw(ArgumentError("Power must be non-negative, got $power < 0."))
    elseif power == 0
        out = similar(a, ())
        out[] = one(eltype(a))
        return out
    else power == 1
        out = a
        for i in 2:power
            out = kronecker_product(out, a)
        end
        out
    end
end
