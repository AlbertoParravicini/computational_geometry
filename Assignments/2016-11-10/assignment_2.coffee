###################################
# UTILITIES #######################
###################################

class Point
  x: 0.0
  y: 0.0
  constructor: (@x, @y) ->

swap = (list, index_1, index_2) ->
  temp = list[index_1]
  list[index_1] = list[index_2]
  list[index_2] = temp

squared_distance = (a, b) ->
  (a.x - b.x) ** 2 + (a.y - b.y) ** 2


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
# POINT INSIDE TRIANGLE ###########
# Check if the point p lies inside the triangle formed by a, b, c.
# Note: if p lies on an edge, it isn't considered to be inside the triangle.
# Based on "http://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle"
point_inside_triangle = (a, b, c, p) ->
  # The points a, b, c are collinear!
  if area_of_triangle(a, b, c, divide = false, abs = false) == 0 
    return false

  b1 = orientation_test(a, b, p) > 0
  b2 = orientation_test(b, c, p) > 0
  b3 = orientation_test(c, a, p) > 0

  return (b1 == b2) && (b2 == b3)




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
console.log points

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
# ASSIGNMENT 2 ####################
###################################

# Binary search code inspired by "https://www.nczonline.net/blog/2009/09/01/computer-science-in-javascript-binary-search/"

###################################
# POINT INCLUSION IN HULL #########
###################################

# Find if a given point is inside a convex polygon.
# Note that the input list of points must be convex,
# and must be radially sorted counter-clockwise, 
# starting from the point with smallest x
inclusion_in_hull = (points, new_point) ->

  # pick the first point p0 of the hull as reference
  # pick the start and stop indexes
  # pick the middle index 
  # if  p0-q-middle is left and p0-q-middle+1 is right, stop
  # if both are left, q is below:
  #   stop = middle - 1,
  #   middle = ...
  # else q is above

  p0 = points[0]
  start_index = 1
  stop_index = points.length - 1
  middle = Math.floor((stop_index + start_index) / 2)

  while (start_index < stop_index) 
    o1 = orientation_test(p0, points[middle], new_point)
    o2 = orientation_test(p0, points[middle + 1], new_point)
    console.log points[middle], points[middle + 1]
    console.log o1, o2
    if o1 >= 0 and o2 <= 0 
      return if orientation_test(points[middle], points[middle + 1], new_point) > 0 then [true, points[0], points[middle], points[middle + 1]] else false
    else 
      if o1 >= 0 and o2 >= 0
        start_index = middle + 1
      else 
        stop_index = middle

    middle = Math.floor((stop_index + start_index) / 2)
  return false





###################################
# FIND TANGENTS TO A POLYGON, LINEAR TIME
###################################
# Find the tangents of a point to a given convex polygon.
# Note that the input list of points must be convex,
# and must be radially sorted counter-clockwise, 
# starting from the point with smallest x.
# Works in linear time, inspired by "http://geomalgorithms.com/a15-_tangents.html"
find_tangents = (input_points, new_point) ->
  points = input_points.slice()
  if inclusion_in_hull(points, new_point) 
    console.log "The point ", new_point, "is inside the polygon!"
    return false

  points = points.concat([points[0]])

  v_r = points[0]
  v_l = points[0]
  
  for i in [1..points.length-2]
    e_prev = orientation_test(points[i - 1], points[i], new_point) >= 0
    e_next = orientation_test(points[i], points[i + 1], new_point) >= 0
    if !e_prev and e_next
      v_r = points[i]
    else if e_prev and !e_next
      v_l = points[i]

  return [true, v_l, v_r]


# Given a convex polygon and an external point, find the edge of the polygon that intersect the line 
# given by the external point and the leftmost point of the polygon.
find_intersecting_edge = (input_points, new_point) -> 
  list = input_points.slice(0)
  
  if inclusion_in_hull(list, new_point) 
    console.log "The point ", new_point, "is inside the polygon!"
    return false 

  list = list.concat([list[0]])
  start = 0
  stop = list.length - 1

  middle = Math.floor((start + stop) / 2)

  while start < stop
    o1 = orientation_test(new_point, list[0], list[middle])
    o2 = orientation_test(new_point, list[0], list[middle + 1])
    if (new_point.x <= list[0].x) 
      if o1 <= 0 and o2 >= 0
        return [middle, list[middle], list[middle + 1]]
      else if o1 >= 0 and o2 >= 0
        stop = middle
      else     
        start = middle + 1

    else 
      if o1 >= 0 and o2 <= 0
        return [middle, list[middle], list[middle + 1]] 
      else if o1 >= 0 and o2 >= 0
        start = middle + 1
      else
        stop = middle
      
    middle = Math.floor((start + stop) / 2)

  if new_point.y < points[0].y  
    return [list.length - 2, list[points.length - 2], list[0]]
  else 
    return [0, list[0], list[1]]


###################################
# FIND TANGENTS TO A POLYGON, BINARY SEARCH
###################################
# Find the tangents of a point to a given convex polygon.
# Note that the input list of points must be convex,
# and must be radially sorted counter-clockwise, 
# starting from the point with smallest x.
find_tangents_bin_search = (input_points, new_point) ->
  points = input_points.slice(0)
  
  if inclusion_in_hull(points, new_point) 
    console.log "The point ", new_point, "is inside the polygon!"
    return false 


  # Find where to split the polygon.
  intersecting_edge = find_intersecting_edge(points, new_point)

  stop_bottom = intersecting_edge[0]
  
  start_top = stop_bottom + 1
  # Needed to handle the tangents to the second edge.
  if stop_bottom == 1 
    stop_bottom = 2

  points = points.concat([points[0]])
  start = 0
  stop = points.length - 1

  middle = Math.floor((start + stop) / 2)

  middle_bottom = Math.floor((start + stop_bottom) / 2)
  middle_top = Math.floor((start_top + stop) / 2)

  v_b = false
  v_t = false

  # Find the bottom tangent
  while (start < stop_bottom)
    o_bottom_1 = orientation_test(new_point, points[middle_bottom - 1], points[middle_bottom])
    o_bottom_2 = orientation_test(new_point, points[middle_bottom], points[middle_bottom + 1])
    if o_bottom_1 * o_bottom_2 <= 0
      v_b = new Point(points[middle_bottom].x, points[middle_bottom].y)
      break
    else if o_bottom_1 <= 0 and o_bottom_2 <= 0
      if new_point.x < points[0].x 
        start = middle_bottom + 1
      else
        stop_bottom = middle_bottom
    else if o_bottom_1 >= 0 and o_bottom_2 >= 0
      if new_point.x < points[0].x 
        stop_bottom = middle_bottom 
      else
          start = middle_bottom + 1
    middle_bottom = Math.floor((start + stop_bottom) / 2)

  # Find the top tangent
  while (start_top < stop)    
    o_top_1 = orientation_test(new_point, points[middle_top - 1], points[middle_top])
    o_top_2 = orientation_test(new_point, points[middle_top], points[middle_top + 1])
    if o_top_1 * o_top_2 <= 0
      v_t = new Point(points[middle_top].x, points[middle_top].y)
      break
    else if o_top_1 >= 0 and o_top_2 >= 0
      if new_point.x < points[0].x 
        start_top = middle_top + 1
      else 
        stop = middle_top 
    else if o_top_1 <= 0 and o_top_2 <= 0
      if new_point.x < points[0].x 
        stop = middle_top 
      else
        start_top = middle_top + 1
    middle_top = Math.floor((start_top + stop) / 2)
 
  v_b = points[middle_bottom]
  v_t = points[middle_top]
 
  return [true, v_b, v_t]


points = [new Point(0.1, 7), new Point(2, 4), new Point(8, 1), new Point(5, 10)]
new_point = new Point(0.0, 4)

console.log find_tangents_bin_search(points, new_point)


