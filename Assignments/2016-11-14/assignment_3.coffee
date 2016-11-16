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
# ASSIGNMENT 3 ####################
###################################

# Test if the orientation of a simple polygon is clockwise (output: true) or counter-clockwise (output: false).
# Based on the Shoelace formula and on "http://stackoverflow.com/questions/1165647/how-to-determine-if-a-list-of-polygon-points-are-in-clockwise-order" 
simple_polygon_orientation_clockwise = (input_simple_polygon) ->
  if input_simple_polygon.length < 3
    throw(new Error("the size of the input polygon is ", input_simple_polygon.length))
  points = input_simple_polygon.slice().concat(input_simple_polygon[0])

  area = 0
  for i in [1...points.length]
    area += (points[i].x - points[i - 1].x) * (points[i].y + points[i - 1].y)
  return if area > 0 then true else false

# Check if adding a given new point to a list of points (sorted cw or ccw) creates a self-intersection.
check_self_intersection_new_point = (input_points_list, new_point) ->
  # If we have just 0 or 1 vertex, we have no self-intersection.
  if input_points_list.length < 2
    return false
  # If we have just two vertices and the new point is not one of them,
  # we have no self-intersection.
  if input_points_list.length == 2 and orientation_test(input_points_list[0], input_points_list[1], new_point) != 0
    return false
  points = input_points_list.slice()

  for i in [1..points.length - 2]
    o1 = orientation_test(points[i - 1], points[i], points[points.length - 1])
    o2 = orientation_test(points[i - 1], points[i], new_point)

    o3 = orientation_test(points[points.length - 1], new_point, points[i - 1])
    o4 = orientation_test(points[points.length - 1], new_point, points[i])

    # We have a self intersection.
    if o1 * o2 < 0 and o3 * o4 < 0
      return true

  return false

# Check if the horizontal ray at the given height intersect the line passing through p_1 and p_2.
# Inspired by https://rosettacode.org/wiki/Ray-casting_algorithm#CoffeeScript
check_horizontal_intersection = (p_1, p_2, query_point) ->
  # Make sure that a is always the bottom point.
  [a,b] = if p_1.y < p_2.y
              [p_1,p_2]
          else
              [p_2,p_1]
  # If the query point lies at the same height of a vertex, move it sightly above.
  # This is coherent with the hypothesis of strict inclusion.
  if query_point.y == a.y or query_point.y == a.y
      query_point.y += Number.MIN_VALUE
 
  if (a.y - query_point.y) * (b.y - query_point.y) < 0 and orientation_test(a, b, query_point) < 0
    return true
  else return false

# Check if the given query point is included in the given simple polygon.
check_inclusion_in_polygon = (input_simple_polygon, query_point) ->
  if input_simple_polygon.length < 3
    throw(new Error("the size of the input polygon is ", input_simple_polygon.length))
  points = input_simple_polygon.slice()

  intersection_count = 0
  for i in [1..points.length]
    p_1 = points[i - 1]
    p_2 = points[i %% points.length]
 
    if check_horizontal_intersection(p_1, p_2, query_point)
        intersection_count += 1
  return intersection_count %% 2 != 0 
