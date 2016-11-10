###################################
# UTILITIES #######################
###################################

class Point
  x: 0.0
  y: 0.0
  constructor: (@x, @y) ->

area_of_triangle = (a, b, c, abs = true, divide = true) ->
  console.log a, b, c
  res = (a.x * b.y) + (a.y * c.x) + (b.x * c.y) - (b.y * c.x) - (c.y * a.x) - (b.x * a.y)
  if divide == true
    res = (1 / 2) * res
  if abs == true
    res = Math.abs(res)

  console.log "area: ", res
  return res

swap = (list, index_1, index_2) ->
  temp = list[index_1]
  list[index_1] = list[index_2]
  list[index_2] = temp

squared_distance = (a, b) ->
  (a.x - b.x) ** 2 + (a.y - b.y) ** 2





###################################
# ASSIGNMENT ######################
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


console.log "\nTest orientation_test"
p = new Point(3, 1)
q = new Point(4, 3)
r = new Point(10, 2)
console.log p, q, r
result = orientation_test(p, q, r)
console.log result
switch result
  when 0 then console.log "r is on the same line as p and q"
  when 1 then console.log "r is on the left of p and q"
  else console.log "r is on the right of p and q"

# Check if the angle anchor-a is bigger than the angle anchor-b.
compare_by_angle = (anchor, a, b) ->
  orientation = orientation_test(anchor, a, b)
  # if orientation < 0, anchor-a is bigger than anchor-b, as we have a right turn.
  if orientation == 0 
    if squared_distance(anchor, a) >= squared_distance(anchor, b)
      return true
    else return false
  else if orientation < 0
      return true
  else return false

console.log "\nTest compare"
anchor = new Point(0, 0)
a = new Point(4, -2)
b = new Point(2, 2)
console.log anchor, a, b
result = compare_by_angle(anchor, a, b)
if result == false
  console.log "a is smaller than b"
else console.log "a is bigger than b"

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

console.log "\nTest point_inside_triangle"
a = new Point(-3, 1)
b = new Point(1, 5)
c = new Point(3, 1)
p = new Point(10, 2)

console.log "abc: ", a, b, c
console.log "p: ", p

console.log point_inside_triangle(a, b, c, p)

# Check if the point p lies inside the triangle formed by a, b, c.
# In this case, the given points are converted to baricentric coordinates.
# Note: if p lies on an edge, it isn't considered to be inside the triangle.
# Based on "http://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/"
point_inside_triangle_baricentric = (a, b, c, p) ->
  area_abc = area_of_triangle(a, b, c)
  # The points a, b, c are collinear!
  if area_abc == 0 
    return false

  alfa = area_of_triangle(p, b, c) 
  beta = area_of_triangle(p, a, c) 
  gamma = area_of_triangle(p, a, b)

  return alfa + beta + gamma == area_abc

console.log "\nTest point_inside_baricentric"
console.log point_inside_triangle_baricentric(a, b, c, p)




###################################
# RADIAL SORT #####################
###################################
points = [new Point(1, 1), new Point(-2, 1), new Point(-1, 3), new Point(2, 1), new Point(2, -2), new Point(-1, -2), new Point(2, 1)]#, new Point(2, -2), new Point(2, 1), new Point(1, 1), new Point(-1, -2), new Point(4, -2), new Point(0, 0)]

for p in points
  p.x -= anchor.x
  p.y -= anchor.y
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

console.log "\nTesting radial sort"
console.log points
radial_sort(points, anchor = new Point(0,0))
console.log(points)





###################################
# CONVEX HULL #####################
###################################
# points = [new Point(-3, 1), new Point(1, 5), new Point(-4, -4), new Point(1, -3), new Point(0, 2), new Point(0, -3),
#           new Point(-3, 4), new Point(-1, 3), new Point(-3, -3), new Point(3, 1), new Point(4, 3), new Point(-3, -1)]
points = [new Point(-1, 3), new Point(-1, -2), new Point(2, -2), new Point(2, 1), new Point(1, 1), new Point(-2, 1), new Point(4, -2), new Point(0, 0)]

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
  console.log "sorted: \n", points
  # If more points have the same angle w.r.t. the anchor, keep only the farthest one.
  i = 1
  while i < points.length-1 and (orientation_test(anchor, points[i], points[i+1]) == 0)
    points.splice(i, 1)
  console.log "sorted2: \n", points

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
      if convex_hull.length < 2
        console.log "alert: ", convex_hull
      convex_hull.pop()  
    # Once no new right turns are found, add the point that gives a left turn.   
    convex_hull.push(new Point(points[i].x, points[i].y))

  return convex_hull

# Test convex hull
points = convex_hull_graham_scan(points)
console.log points



