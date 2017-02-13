# Default comparator used in binary search.
default_comparator = (points, value, middle) ->
    if points[middle] < value   
        return 1
    else if points[middle] > value
        return -1
    else return 0

# Find if a point is included in the k-th zonoid.
# "value" is the point that is considered, while "points" is the set of points,
# with n = number of points of the set.
# middle is k - 1.
zonoid_inclusion_comparator = (points, value, middle) ->
    # Pseudo-code:
    # k_zonoid = compute_zonoid(points, k: middle + 1)
    # if (points.length == (middle + 1)) and inclusion_in_polygon(k_zonoid, value)
    #    return 0
    # res = inclusion_in_polygon(k_zonoid, value)
    # if res return 1 else return -1

    # fake code for TESTING
    return if (middle + 1) <=  Math.floor(value) then 1 else -1

# Generic implementation of binary search. 
# It returns the position of the found element, or False if not found. 

# "force_return" can be used to return the index of the next bigger element, 
# if the desired element isn't found.
# If the element to be found is bigger than all the elements in the array, 
# it returns the index of the last element, i.e. the biggest in the array.
binary_search = (points, value, {comparator, force_return, start, stop} = {}) ->
    comparator ?= default_comparator
    force_return ?= false
    start ?= 0
    stop ?= points.length - 1

    while start < stop
        middle = Math.floor((start + stop) / 2)
        res = comparator(points, value, middle)
        if res > 0
            start = middle + 1
        else if res < 0
            stop = middle
        else 
            return middle
    
    return if !force_return then false else Math.floor((start + stop) / 2) 



#######################
# TESTING #############
#######################   
a = [1, 2, 3, 4, 5, 6]

zonoid_depth = binary_search(a, 1, comparator: zonoid_inclusion_comparator, force_return: true)
# If the point is not exactly the mean point, subtract 1 to find the smallest zonoid that includes the point
# Doesnt work for centroid!

console.log "zonoid depth: ", zonoid_depth

