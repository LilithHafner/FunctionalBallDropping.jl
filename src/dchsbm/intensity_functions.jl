sorted_unique_count(m) = isempty(m) ? 0 : 1+sum(m[2:end].≠m[1:end-1])

"""
    inverse_power_intensity_function(α)

Returns an intensity function that is of the form ``n^{-α}`` where ``n`` is the number of
distinct community groups a multiset contains. Input multisets must be sorted.
"""
inverse_power_intensity_function(α::Real) = m -> 1/sorted_unique_count(m)^α

"""
    all_or_nothing_intensity_function(α, β)

Returns an intensity function that is `α` when a multiset contains only a single community
and `β` otherwise.
"""
all_or_nothing_intensity_function(α::Real, β::Real) = m -> isempty(m) || all(isequal(first(m)), m) ? α : β
# not using allequal because it was introduced in 1.8.
