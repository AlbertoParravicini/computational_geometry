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
# ASSIGNMENT 1 ####################
###################################

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

# FInd the required element in a sorted list.
# Inspired by "https://www.nczonline.net/blog/2009/09/01/computer-science-in-javascript-binary-search/"
binary_search = (list, elem) ->
  start_index = 0
  stop_index = list.length - 1
  middle = Math.floor((stop_index + start_index) / 2)

  while (list[middle] != elem and start_index < stop_index) 
    if (elem < list[middle])
      stop_index = middle - 1
    else if (elem > list[middle])
      start_index = middle + 1
      
    middle = Math.floor((stop_index + start_index) / 2)
  
  if list[middle] != elem  
    throw(new Error("Element not found!"))
  return middle

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
      return orientation_test(points[middle], points[middle + 1], new_point) > 0
    else 
      if o1 >= 0 and o2 >= 0
        start_index = middle + 1
      else 
        stop_index = middle

    middle = Math.floor((stop_index + start_index) / 2)
  
  return false



points = [new Point(-1, 3), new Point(-1, -2), new Point(2, -2), new Point(2, 1), new Point(1, 1),
     new Point(-2, 1), new Point(4, -2)]
new_point = new Point(-1, 2)

points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
    new Point(200, 320), new Point(50, 40),new Point(50, 350), new Point(150, 350),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];
new_point = new Point(153, 44)

console.log points
hull = convex_hull_graham_scan(points)
console.log hull


console.log inclusion_in_hull(hull, new_point)