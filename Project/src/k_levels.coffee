w = 640
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
  k_level_points.push(current_line.start)

  still_in_canvas = true

  while still_in_canvas
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
    
    if first_intersection == -1
      first_intersection = 
    # Update the current line, then proceed in the k-level computation
    k_level_points.push(intersections[first_intersection])
    current_line = lines[first_intersection]

    # If we went outside the canvas, remove the last point and add the intersection of
    # the current line with the canvas
    if k_level_points[k_level_points.length - 1].x > w 
      still_in_canvas = false
      last_point = k_level_points[k_level_points.length - 1]
      second_to_last_point = k_level_points[k_level_points.length - 2]
      k_level_points.splice(-1,1)
     
      k_level_points.push(new Point(w, ((last_point.y - second_to_last_point.y) / (last_point.x - second_to_last_point.x)) * (w - second_to_last_point.x) + second_to_last_point.y))      
    if k_level_points[k_level_points.length - 1].y > h 
      still_in_canvas = false
      last_point = k_level_points[k_level_points.length - 1]
      second_to_last_point = k_level_points[k_level_points.length - 2]
      k_level_points.splice(-1,1)
      
      k_level_points.push(new Point(((-last_point.x + second_to_last_point.x) / (last_point.y - second_to_last_point.y)) * (h - last_point.y) + second_to_last_point.x, h))      
    if k_level_points[k_level_points.length - 1].y < 0 
      still_in_canvas = false
      last_point = k_level_points[k_level_points.length - 1]
      second_to_last_point = k_level_points[k_level_points.length - 2]
      k_level_points.splice(-1,1)
      k_level_points.push(new Point(second_to_last_point.x, h))      



  return k_level_points
  

