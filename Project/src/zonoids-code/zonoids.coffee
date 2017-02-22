# # # Import classes
# {Point, KSetElem} = require('./utils.coffee')
# # # Import functions
# {swap, squared_distance, orientation_test} = require('./utils.coffee')

# _ = require("./underscore.js")
# utils = require("./utils.coffee")

a = new Point(2, 3)



b = new KSetElem(4,5,0.1)



console.log _.isEqual(a, a)

console.log b


# Check if the k_set A is contained in the list of k_sets B
in_set = (A, B) ->
  for B_i in B 
    if set_equal(A, B_i)
      return true
  return false

# Check if two k-sets have the same elements
set_equal = (A, B) ->
  if a.length != b.length
    return false
  for a in A 
    flag = false
    for b in B
      if _.isEqual(a, b)
        flag = true
        break
    if !flag
      return false
  return true

compute_k_sets_disc = (S, {k} = {}) ->
  k ?= 1

  n_points = S.length
  k_sets = []

  # Handle case where n_points == k 
  if n_points == k
    n_set = []
    for p in S 
      n_set.push(new KSetElem(p.x, p.y, 1 / k))
    k_sets.push(n_set)
    return k_sets

  # If n_points != k, consider the line passing every pair of points
  for i in [0..n_points - 1]
    for j in [0..n_points - 1]
      if i != j

        # Set containing the points on the left of i-j. 
        temp_set = []

        # console.log "----------------\n\n"
        # console.log "considering line i: ", S[i], " -- j; ", S[j], "\n"

        for n in [0..n_points - 1]
          # Test the position of every other point w.r.t. the line passing thourgh i and j,
          # and put the point in the temp_set if it falls on the left of the line. 
          if (n != i) and (n != j) 
            pos = orientation_test(S[i], S[j], S[n])
            if pos > 0
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k))
        #     console.log "evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", (if pos > 0 then "left" else "right"), "\n"
        
        # console.log "temp_set: ", temp_set, "\n"

        # Process temp_set
        if temp_set.length > 0
          # Handle case with k = n_points - 1, add to the k-set every points except the 1-set 
          if (k == n_points - 1) and (temp_set.length == 1)
            n_minus_1_set = []
            for p in S             
              if (p.x != temp_set[0].x) or (p.y != temp_set[0].y)
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 / k))
              # else console.log "rejected:", p
            # If the k_set hasn't been seen yet, add it to the list.
            if !in_set(n_minus_1_set, k_sets)
              k_sets.push(n_minus_1_set)

          # Case where the set has the desired length
          else if (temp_set.length == k) and !(in_set(temp_set, k_sets))
            k_sets.push(temp_set)
  return k_sets

# Compute the k-sets for discrete k,
# and return them as a list of KSet objects insted that as a list of lists of points.
# The KSet object contains the mean point of the k-set,
# and the points that separate the k-set from the other points.
compute_k_sets_disc_2 = (S, {k} = {}) ->
  k ?= 1

  n_points = S.length
  k_sets = []

  # Handle case where n_points == k 
  if n_points == k
    n_set = new KSet()
    for p in S 
      n_set.elem_list.push(new KSetElem(p.x, p.y, 1 / k))
    n_set.compute_mean()
    k_sets.push(n_set)
    return k_sets

  # If n_points != k, consider the line passing every pair of points
  for i in [0..n_points - 1]
    for j in [0..n_points - 1]
      if i != j

        # Set containing the points on the left of i-j. 
        temp_set = []

        # console.log "----------------\n\n"
        # console.log "considering line i: ", S[i], " -- j; ", S[j], "\n"

        for n in [0..n_points - 1]
          # Test the position of every other point w.r.t. the line passing thourgh i and j,
          # and put the point in the temp_set if it falls on the left of the line. 
          if (n != i) and (n != j) 
            pos = orientation_test(S[i], S[j], S[n])
            if pos > 0
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k))
        #     console.log "evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", (if pos > 0 then "left" else "right"), "\n"
        
        # console.log "temp_set: ", temp_set, "\n"

        # Process temp_set
        if temp_set.length > 0
          # Handle case with k = n_points - 1, add to the k-set every points except the 1-set 
          if (k == n_points - 1) and (temp_set.length == 1)
            n_minus_1_set = []
            for p in S             
              if (p.x != temp_set[0].x) or (p.y != temp_set[0].y)
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 / k))
              # else console.log "rejected:", p
            # If the k_set hasn't been seen yet, add it to the list.
            if !in_set(n_minus_1_set, k_sets)
              k_set = new KSet()
              k_set.elem_list = n_minus_1_set
              k_set.compute_mean()
              k_set.separator = [S[i], S[j]]
              k_sets.push(k_set)

          # Case where the set has the desired length
          else if (temp_set.length == k) and !(in_set(temp_set, k_sets))
            k_set = new KSet()
            k_set.elem_list = temp_set
            k_set.compute_mean()
            k_set.separator = [S[i], S[j]]
            k_sets.push(k_set)
  return k_sets


compute_k_sets_cont = (S, {k} = {}) ->
  k ?= 1

  n_points = S.length
  k_sets = []

  # Handle case where n_points == k 
  if n_points == k
    n_set = []
    for p in S 
      n_set.push(new KSetElem(p.x, p.y, 1 / k))
    k_sets.push(n_set)
    return k_sets

  # If n_points != k, consider the line passing every pair of points
  for i in [0..n_points - 1]
    for j in [0..n_points - 1]
      if i != j

        # Set containing the points on the left of i-j. 
        temp_set = []

        # console.log "----------------\n\n"
        # console.log "considering line i: ", S[i], " -- j; ", S[j], "\n"

        for n in [0..n_points - 1]
          # Test the position of every other point w.r.t. the line passing thourgh i and j,
          # and put the point in the temp_set if it falls on the left of the line. 
          if (n != i) and (n != j) 
            pos = orientation_test(S[i], S[j], S[n])
            if pos > 0
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k))
            #console.log "evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", (if pos > 0 then "left" else "right"), "\n"
        
        #console.log "temp_set: ", temp_set, "\n"

        # Process temp_set
        if temp_set.length > 0
          # Handle case with k = n_points - 1, add to the k-set every points except the 1-set 
          if (Math.floor(k) == n_points - 1) and (temp_set.length == 1)
            n_minus_1_set = []
            for p in S             
              if (p.x != temp_set[0].x) or (p.y != temp_set[0].y)
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 / k))
              else if Math.floor(k) != k # If k is not integer
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 - Math.floor(k) / k))
            # If the k_set hasn't been seen yet, add it to the list.
            if !in_set(n_minus_1_set, k_sets) 
              k_sets.push(n_minus_1_set)

          # Case where the set has the desired length
          else if Math.floor(k) == k
            if (temp_set.length == k) and !(in_set(temp_set, k_sets))
              k_sets.push(temp_set)
          else 
            temp_set_1 = temp_set.slice()
            temp_set_2 = temp_set.slice()
            temp_set_1.push((new KSetElem(S[i].x, S[i].y, 1 - Math.floor(k) / k)))
            temp_set_2.push((new KSetElem(S[j].x, S[j].y, 1 - Math.floor(k) / k)))
            if (temp_set.length == Math.floor(k)) and !in_set(temp_set_1, k_sets)
              k_sets.push(temp_set_1)
            if (temp_set.length == Math.floor(k)) and !in_set(temp_set_2, k_sets)
              k_sets.push(temp_set_2)
  return k_sets 
        
compute_zonoid = (S, {k, discrete} = {}) ->
  k ?= 1
  discrete ?= false
  
  if discrete 
    k_sets = compute_k_sets_disc(S, k:k)
  else
    k_sets = compute_k_sets_cont(S, k:k)

  zonoid = []

  for k_set_i in k_sets
    #console.log "computing vertex of: ", k_set_i, "\n"
    v_x = 0
    v_y = 0
    for p_i in k_set_i
      v_x += p_i.x * p_i.weight
      v_y += p_i.y * p_i.weight
    zonoid.push(new Point(v_x, v_y))
  return zonoid    

# Compute the (discrete!) zonoid depth of a given point.
compute_zonoid_depth = (S, query_point, {return_zonoid} = {}) ->
  
  return_zonoid ?= false
  old_zonoid = []
  zonoid = []
  for k in [1..S.length - 1]
    old_zonoid = zonoid
    zonoid = compute_zonoid(S, k:k, discrete:true)
    res = check_inclusion_in_polygon(radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true), query_point)
    if !res
      if return_zonoid
        return [old_zonoid, k - 1]
      else
        return k - 1
  # If the point is exactly the mean
  mean_zonoid = compute_zonoid(S, k:S.length, discrete:true)
  approx_mean = new Point(Math.floor(mean_zonoid[0].x), Math.floor(mean_zonoid[0].y))
  if _.isEqual(approx_mean, query_point)
    if return_zonoid
      return [mean_zonoid, S.length]
    else
      return S.length
  # The query point is in the (n-1)zonoid
  else 
    if return_zonoid
      return [zonoid, S.length - 1]
    else
      return S.length - 1



