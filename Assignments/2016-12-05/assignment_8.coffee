###################################
# UTILITIES #######################
###################################

# Size of the canvas
w= 1200
h = 800

# Small constant to avoid division by 0
epsilon = 0.000001

# Absolute smallest difference between two horizontal coordinates
# for a line to be considered vertical.
vertical_coeff = 1 

class Point
  x: 0.0
  y: 0.0
  constructor: (@x, @y) ->

  toString: ->
    return "Point(" + this.x + ", " + this.y + ")\n"


swap = (list, index_1, index_2) ->
  temp = list[index_1]
  list[index_1] = list[index_2]
  list[index_2] = temp

squared_distance = (a, b) ->
  (a.x - b.x) ** 2 + (a.y - b.y) ** 2


area_of_triangle = (a, b, c, abs = true, divide = true) ->
  res = (a.x * b.y) + (a.y * c.x) + (b.x * c.y) - (b.y * c.x) - (c.y * a.x) - (b.x * a.y)
  if divide == true
    res = (1 / 2) * res
  if abs == true
    res = Math.abs(res)
  return res



###################################
# ORIENTATION DETERMINANT #########
# Test whether the point "r" lies on the left or on the right
# of the line passing for points "p" and "q".
# Based on "http://dccg.upc.edu/people/vera/wp-content/uploads/2013/06/GeoC-OrientationTests.pdf",
# pages 5-6.
orientation_test = (p, q, r) ->
  #console.log p, q, r
  determinant = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x)
  # determinant == 0: p, q, r are on the same line
  # determinant > 0: r is on the left of p and q (counter-clockwise turn)
  # determinant < 0: r is on the right of p and q (clockwise turn)
  #console.log "det:", determinant, "\n"
  return determinant




###################################
# RADIAL SORT #####################
###################################
# Sort clockwise (or counter-clockwise) a list of points w.r.t. a given anchor point.
# If the points, translated w.r.t. the anchor, span multiple quadrants of the plane,
# they are sorted by taking the positive x semi-axis as starting point.
# Inspired by "http://stackoverflow.com/questions/6989100/sort-points-in-clockwise-order"
radial_sort = (points, anchor, cw) ->
  if points.length == 0
    return []
    
  anchor ?= new Point(points[0].x, points[0].y)
  cw ?= true
  
  points.sort((a, b) ->
    
    if a.x - anchor.x == 0 and a.y - anchor.y == 0 and b.x - anchor.x != 0 and b.y - anchor.y != 0
      return -1
    if a.x - anchor.x != 0 and a.y - anchor.y != 0 and b.x - anchor.x == 0 and b.y - anchor.y == 0
      return 1
    if a.x - anchor.x >= 0 and b.x - anchor.x < 0
      return  -1
    if a.x - anchor.x < 0 and b.x - anchor.x >= 0
      return  1
    if a.x - anchor.x == 0 and b.x - anchor.x == 0
      if a.y - anchor.y < 0 and b.y - anchor.y < 0
        return if a.y < b.y then 1 else -1
      else 
        return if a.y > b.y then 1 else -1
    # Check the position of b wrt the line defined by the anchor and a.
    # b has greater angle than a if it lies on the left of the line.
    orientation = orientation_test(anchor, a, b)
    # if orientation < 0, anchor-a is bigger than anchor-b, as we have a right turn.
    if orientation == 0 
      return if squared_distance(anchor, a) >= squared_distance(anchor, b) then 1 else -1
    else 
      return if orientation > 0 then 1 else -1
    )

  if !cw 
    points.reverse()
    
  return points



###################################
# CONVEX HULL #####################
###################################

# Compute the convex hull of the given list of points by using Graham scan
# Inspired by "http://www.geeksforgeeks.org/convex-hull-set-2-graham-scan/"
convex_hull_graham_scan = (input_points) ->
  points = input_points.slice()
  convex_hull = []
  # Find the point with the smalles x.
  smallest_x_point_index = 0
  for i in [0..points.length - 1]
    if ((points[i].x < points[smallest_x_point_index].x) ||
        ((points[i].x == points[smallest_x_point_index].x) && (points[i].y < points[smallest_x_point_index].y)))
      smallest_x_point_index = i
  # Put the point with smallest x at the beginning of the list.
  swap(points, 0, smallest_x_point_index)

  # Order the list with respect to the angle that each point forms 
  # with the anchor. Given two points a, b, in the output a is before b
  # if the polar angle of a w.r.t the anchor is bigger than the one of b,
  # in counter-clockwise direction.
  anchor = new Point(points[0].x, points[0].y)
  points = [anchor].concat(radial_sort(points[1..], anchor, cw = false))
  # If more points have the same angle w.r.t. the anchor, keep only the farthest one.
  i = 1
  while i < points.length-1 and (orientation_test(anchor, points[i], points[i+1]) == 0)
    points.splice(i, 1)

  # If there are fewer than 3 points, it isn't possible to build a convex hull.
  if points.length < 3
    return []

  # Add the first 3 points to the convex hull.
  # The first 2 will be for sure part of the hull.
  convex_hull.push(new Point(points[0].x, points[0].y))
  convex_hull.push(new Point(points[1].x, points[1].y))
  convex_hull.push(new Point(points[2].x, points[2].y))

  for i in [3..points.length - 1]
    # While the i-th point forms a non-left turn with the last 2 elements of the convex hull...
    while orientation_test(convex_hull[convex_hull.length - 2], convex_hull[convex_hull.length - 1], points[i]) <= 0
      # Delete from the convex hull the point that causes a right turn.
      convex_hull.pop()  
    # Once no new right turns are found, add the point that gives a left turn.   
    convex_hull.push(new Point(points[i].x, points[i].y))

  return convex_hull





###################################
# ASSIGNMENT 7 ####################
###################################

###################################
# Given the parameters m, q, 
# return a line y = m * x + q 
# spanning the entire canvas.
create_line_from_m_q = (m, q) ->
  # Numerical approximation
  if Math.abs(q) <= 0.1
    q = 0

  if m == 0
    return [new Point(0, q), new Point(w, q)]
  # Find the two extreme points of the line.
  start_y = q
  end_y = m * w + q 

  if start_y >= 0 and start_y <= h 
    
    if end_y >= 0 and end_y <= h
      return [new Point(0, start_y), new Point(w, end_y)]
    else if end_y < 0
      return [new Point(0, start_y), new Point(-q / (m + epsilon), 0)]
    else
      return [new Point(0, start_y), new Point((h-q) / (m + epsilon), h)]

  if start_y < 0

    if end_y >= 0 and end_y <= h
      return [new Point(-q / (m + epsilon), 0), new Point(w, end_y)]
    else if end_y > 0
      return [new Point(-q / (m + epsilon), 0), new Point((h-q) / (m + epsilon), h)]
    else   
      console.log "ERROR!"
    
  else

    if end_y >= 0 and end_y <= h
      return [new Point((h-q) / (m + epsilon), h), new Point(w, end_y)]
    else if end_y < 0
      return [new Point((h-q) / (m + epsilon), h), new Point(-q / (m + epsilon), 0)]
    else   
      console.log "ERROR!"


###################################
# Given two points, return a line 
# spanning the entire canvas.
create_line = (p_1, p_2) ->

  # Given p_1 and p_2,
  # express the line as y = m*x + q
  m = (p_2.y - p_1.y) / (p_2.x - p_1.x)
  q = (p_1.y * p_2.x - p_2.y * p_1.x) / (p_2.x - p_1.x)

  return create_line_from_m_q(m, q)



###################################
# Given a set of lines and a point, 
# Translate the lines 
# so that the point becomes the origin
translate_to_origin = (input_lines, point) ->
  lines = []
  for l in input_lines
    lines.push([new Point(l[0].x, l[0].y), new Point(l[1].x, l[1].y)])

  for l in lines
    l[0].x -= point.x
    l[0].y -= point.y
    l[1].x -= point.x
    l[1].y -= point.y

  return lines

###################################
# Given a set of lines and a point
# which is currently the origin, 
# translate the lines back.
translate_back = (input_lines, point) ->
  lines = []
  for l in input_lines
    lines.push([new Point(l[0].x, l[0].y), new Point(l[1].x, l[1].y)])

  for l in lines
    l[0].x += point.x
    l[0].y += point.y
    l[1].x += point.x
    l[1].y += point.y

  return lines


###################################
# Given a set of lines, 
# transform them to dual points
# using the polar duality.
# A line a*x + b*y - 1 = 0
# becomes a point (a, b)
turn_lines_to_polar_point = (input_lines) ->

  polar_points = []

  for l in input_lines
    x_1 = l[0].x
    x_2 = l[1].x
    y_1 = l[0].y
    y_2 = l[1].y

    a = (y_1 - y_2) / (y_1 * x_2 - y_2 * x_1 + epsilon)
    b = (x_2 - x_1) / (y_1 * x_2 - y_2 * x_1 + epsilon)

    polar_points.push(new Point(a, b))
  
  return polar_points


###################################
# Given a set of points, 
# transform them to dual lines
# using the polar duality.
# A point (a, b) 
# becomes a line a*x + b*y - 1 = 0
#
# Lines are returned as a couple of points
# intersecting the canvas.
turn_polar_points_to_lines = (input_points) ->
  lines = []

  for p in input_points
    a = p.x
    b = p.y
    m = -a / (b + epsilon)
    q = 1 / (b + epsilon)
    lines.push([new Point(0, q), new Point(w, m * w + q)])

  return lines


###################################
# Find the lines that contains a point
find_lines = (input_lines, query_point) ->

  lines = translate_to_origin(input_lines, query_point)

  polar_points = turn_lines_to_polar_point(lines)

  hull = convex_hull_graham_scan(polar_points)

  output_lines = turn_polar_points_to_lines(hull)

  output_lines = translate_back(output_lines, query_point)

  final_output_lines = []
  for l in output_lines

    # Numerical approximations
    temp_line = create_line(l[0], l[1])
    if temp_line[0].y < 0
      temp_line[0].y = 0
    if temp_line[1].y < 0
      temp_line[1].y = 0
    if Math.abs(temp_line[0].x - temp_line[1].x) < vertical_coeff
      temp_line[0].y = 0
      temp_line[1].y = h
    final_output_lines.push(temp_line)

  return final_output_lines


###################################
# CHECK LINE INTERSECTION #########
###################################
# Check if the 2 segments intersect.
check_intersection = (edge_1, edge_2) ->
  if edge_1 == null or edge_1 == undefined or edge_2 == null or edge_2 == undefined
    return false

  p_11 = new Point(edge_1[0].x, edge_1[0].y)
  p_12 = new Point(edge_1[1].x, edge_1[1].y)
  p_21 = new Point(edge_2[0].x, edge_2[0].y)
  p_22 = new Point(edge_2[1].x, edge_2[1].y)

  m1 = (p_12.y - p_11.y) / (p_12.x - p_11.x + epsilon)
  m2 = (p_22.y - p_21.y) / (p_22.x - p_21.x + epsilon)
  
  o1 = orientation_test(p_11, p_12, p_21)
  o2 = orientation_test(p_11, p_12, p_22)

  o3 = orientation_test(p_21, p_22, p_11)
  o4 = orientation_test(p_21, p_22, p_12)

  # We have an intersection.
  if o1 * o2 <= 0 and o3 * o4 <= 0
    m1 = (p_12.y - p_11.y) / (p_12.x - p_11.x + epsilon)
    m2 = (p_22.y - p_21.y) / (p_22.x - p_21.x + epsilon)
    q1 = (p_11.y * p_12.x - p_12.y * p_11.x) / (p_12.x - p_11.x + epsilon)
    q2 = (p_21.y * p_22.x - p_22.y * p_21.x) / (p_22.x - p_21.x + epsilon)
    x = (q2 - q1) / (m1 - m2 + epsilon)
    y = (m1 * q2 - m2 * q1) / (m1 - m2 + epsilon)

    
    return new Point(x, y)
  return false



compute_intersections = (input_lines) ->
  intersections = []

  for i in [0..input_lines.length]
    for j in [0..input_lines.length]
      if j > i
        intersection = check_intersection(input_lines[i], input_lines[j])
        if intersection
          intersections.push(intersection)
  return intersections

build_cell = (intersections, input_lines, query_point) ->
  cell = []

  for p in intersections
    no_intersection = true
    # Numerical approximation for segment intersection
    approx_p = new Point(0.99 * p.x + 0.01 * query_point.x, 0.99 * p.y + 0.01 * query_point.y)
    segment = [approx_p, query_point]
    for l in input_lines
      int_flag = check_intersection(segment, l)
      if int_flag
        no_intersection = false
        break
    if no_intersection
      cell.push(p)
  return cell



###################################
# RADIAL SORT #####################
###################################
# Sort clockwise (or counter-clockwise) a list of points w.r.t. a given anchor point.
# If the points, translated w.r.t. the anchor, span multiple quadrants of the plane,
# they are sorted by taking the positive x semi-axis as starting point.
# Inspired by "http://stackoverflow.com/questions/6989100/sort-points-in-clockwise-order"
radial_sort = (points, anchor, cw) ->
  if points.length == 0
    return []
    
  anchor ?= new Point(points[0].x, points[0].y)
  cw ?= true
  
  points.sort((a, b) ->
    
    if a.x - anchor.x == 0 and a.y - anchor.y == 0 and b.x - anchor.x != 0 and b.y - anchor.y != 0
      return -1
    if a.x - anchor.x != 0 and a.y - anchor.y != 0 and b.x - anchor.x == 0 and b.y - anchor.y == 0
      return 1
    if a.x - anchor.x >= 0 and b.x - anchor.x < 0
      return  -1
    if a.x - anchor.x < 0 and b.x - anchor.x >= 0
      return  1
    if a.x - anchor.x == 0 and b.x - anchor.x == 0
      if a.y - anchor.y < 0 and b.y - anchor.y < 0
        return if a.y < b.y then 1 else -1
      else 
        return if a.y > b.y then 1 else -1
    # Check the position of b wrt the line defined by the anchor and a.
    # b has greater angle than a if it lies on the left of the line.
    orientation = orientation_test(anchor, a, b)
    # if orientation < 0, anchor-a is bigger than anchor-b, as we have a right turn.
    if orientation == 0 
      return if squared_distance(anchor, a) >= squared_distance(anchor, b) then 1 else -1
    else 
      return if orientation > 0 then 1 else -1
    )

  if !cw 
    points.reverse()
    
  return points



###################################
# ASSIGNMENT 8 ####################
###################################

##################################
# Given two points, find the 
# line that bisect the two points.
# The line is returned in the form 
# y = m*x + q, and the parameters m, q
# are returned.
find_bisecting_line_parameters = (p_1, p_2) ->
  m = (p_1.x - p_2.x) / (p_2.y - p_1.y + epsilon)
  q = (p_1.y + p_2.y) / 2 - m * (p_1.x + p_2.x) / 2
  return [m, q]


##################################
# Given a set of points and a query point,
# build the cell from the bisectors between 
# the query point and the other points.
find_cell = (input_points, query_point) ->
  lines = [[new Point(0,0), new Point(0, h)], 
           [new Point(0, h), new Point(w, h)],
           [new Point(w, h), new Point(w, 0)],
           [new Point(w, 0), new Point(0, 0)]]

  for p_i in input_points
    if p_i.x != query_point.x and p_i.y != query_point.y
      [m, q] = find_bisecting_line_parameters(query_point, p_i)
      lines.push(create_line_from_m_q(m, q))

  res = find_lines(lines, query_point)    
  inter = compute_intersections(res)
  cell = build_cell(inter, res, query_point)

  return [lines, res, inter, cell]


find_cells = (input_points) ->
  cells = []

  for p in input_points
    cell = find_cell(input_points, p)[3]
    cells.push(cell)
  return cells

