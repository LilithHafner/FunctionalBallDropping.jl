"""
Chase Holdener and Nishank Jajodia
Nicole Eikmeier, Grinnell College.
7-13-2021
"""

"""
This code calculates the edge placement probability for a given multiset and scaling factor
Parameters:
* multiset is a vector of integers denoting which block we are working with
* scaling_factor is a floating point number that signifies the highest possible edge placement probability
"""
function number_of_groups_affinity_function(multiset, scaling_factor::Float64)
    count = 0
    group_count = 0
    max = 0
    for i in 1:(length(multiset)-1)
        if(multiset[i]==multiset[i+1])
            count += 1
            group_count += 1
            if(group_count > max)
                max = group_count
            end
        else
            group_count = 0
        end
    end
    max += 1
    P = scaling_factor * (10.0 ^ (-((length(multiset) - max)+(length(multiset)-count- 1))))
    return P
end
