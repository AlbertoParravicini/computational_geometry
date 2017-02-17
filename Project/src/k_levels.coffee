w = 1200
h = 480

compute_k_level = (input_lines, k) ->
  console.log input_lines
  lines = input_lines.slice()

  # Store the points that will compose the k-level
  k_level_points = []

  # Find the k-th line starting from the bottom 
  # Sort the lines based on the value of q, then pick the k-th one.
  lines.sort((a, b) ->
            if a.q > b.q
              return 1
            else if a.q < b.q
              return -1
            else return 0
            )
  console.log "\n\nSORTED:\n" + lines

  # Store the current line of the k_set
  current_line = lines[k - 1]
  k_level_points.push(new Point(0, current_line.q))

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
  

