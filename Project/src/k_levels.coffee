w = 1200
h = 700

compute_k_level = (input_lines, k) ->
  console.log input_lines
  lines = input_lines.slice()

  # Store the points that will compose the k-level
  k_level_points = []

  # Find the k-th line starting from the bottom 
  # Sort the lines based on the value of q, then pick the k-th one.
  lines.sort((a, b) ->
            if a.m * -10000 + a.q > b.m * -10000 + b.q
              return 1
            else if a.m * -10000 + a.q < b.m * -10000 + b.q
              return -1
            else return 0
            )
  console.log "\n\nSORTED:\n" + lines

  # Store the current line of the k_set
  current_line = lines[k - 1]
  k_level_points.push(new Point(-10000, current_line.m * -10000 + current_line.q))

  while true
    # Compute the intersection of the current line with all the other lines.
    # If parallel, the intersection is +Inf
    intersections = []
    for l_i in lines
      if current_line.m == l_i.m 
        intersections.push(new Point(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY))
      else
        x_i = (l_i.q - current_line.q) / (current_line.m - l_i.m)
        y_i = l_i.m * x_i + l_i.q
        intersections.push(new Point(x_i, y_i))
    
    # Find the intersection with smaller x, but bigger than the current point.x,
    # which correspond to the first line encountered by the current one.
    first_intersection = -1
    best_so_far = Number.POSITIVE_INFINITY
    for i in [0..intersections.length - 1]
      if intersections[i].x > k_level_points[k_level_points.length - 1].x
        if intersections[i].x < best_so_far
          first_intersection = i 
          best_so_far = intersections[i].x
    
    # If no intersections were found, the k-level is over.
    if first_intersection == -1
      k_level_points.push(new Point(10000, current_line.m * 10000 + current_line.q))
      break
    # Update the current line, then proceed in the k-level computation
    k_level_points.push(intersections[first_intersection])
    current_line = lines[first_intersection]

  return k_level_points
  

# Find the vertices of the k-level such that
# k - 2 lines are above them, instead of k - 1.
# In practice, a vertex is reflex if the k-level makes a left turn in that vertex.
# up: if true, compute vertices with k - 2 lines ABOVE them
# if false, compute vertices with k - 2 lines BELOW them
compute_reflex_vertices = (k_level, {up} = {}) ->
  up ?= false
  reflex_vertices = []
  for i in [1..k_level.length - 2]
    res = orientation_test(k_level[i - 1], k_level[i], k_level[i + 1])
    if (res < 0 and !up) or (res > 0 and up)
      reflex_vertices.push(k_level[i])
  return reflex_vertices

# up: if true, compute the UPPER half of the zonoid
# if false, compute the LOWER half of the zonoid
compute_zonoid_vertices_from_reflex = (reflex_vertices, lines, {up} = {}) ->
  up ?= false

  zonoid_vertices = []

  for r_i in reflex_vertices 
    intersections = []
    # Push twice the reflex vertex, as it corresponds to 2 points in the primal k-sets
    intersections.push(r_i)
    intersections.push(r_i)
    # Find intersections with the vertical ray in the reflex vertex, and above the k-level
    for l_i in lines
      vertical_intersection = l_i.m * r_i.x + l_i.q
      # Need a small constant to take care of numerical imprecisions.
      if (vertical_intersection < r_i.y - 0.000001 and up) or (vertical_intersection > r_i.y - 0.000001 and !up)
        intersections.push(new Point(r_i.x, vertical_intersection))
    # Compute the mean of those intersections 
    zonoid_vertex = new Point(0, 0)

    for p_i in intersections
      zonoid_vertex.x += p_i.x
      zonoid_vertex.y += p_i.y 
    zonoid_vertex.x /= intersections.length
    zonoid_vertex.y /= intersections.length
    zonoid_vertices.push(zonoid_vertex)
  
  return zonoid_vertices

