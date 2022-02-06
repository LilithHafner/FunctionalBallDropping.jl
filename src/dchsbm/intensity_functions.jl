sorted_unique_count(m) = isempty(m) ? 0 : 1+sum(m[2:end].≠m[1:end-1])

inverse_power_intensity_function(α::Real) = m -> 1/sorted_unique_count(m)^α
all_or_nothing_intensity_function(α::Real, β::Real) = m -> all(i -> i == first(m), m) ? α : β
