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

# Test if the orientation of a simple polygon is clockwise (output: true) or counter-clockwise (output: false).
# Based on the Shoelace formula and on "http://stackoverflow.com/questions/1165647/how-to-determine-if-a-list-of-polygon-points-are-in-clockwise-order" 
simple_polygon_orientation_clockwise = (input_simple_polygon) ->
  if input_simple_polygon.length < 3
    throw(new Error("the size of the input polygon is ", input_simple_polygon.length))
 
  area = 0
  for i in [1..input_simple_polygon.length]
    area += (input_simple_polygon[i %% input_simple_polygon.length].x - input_simple_polygon[i - 1].x) * (input_simple_polygon[i %% input_simple_polygon.length].y + input_simple_polygon[i - 1].y)
  return if area > 0 then true else false

# Check if adding a given new point to a list of points (sorted cw or ccw) creates a self-intersection.
check_self_intersection_new_point = (input_points_list, new_point) ->
  # If we have just 0 or 1 vertices, we have no self-intersection.
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


###################################
# ASSIGNMENT 4 ####################
###################################

###################################
# CHECK IF A VERTEX IS PART OF A EAR
# Given a simple polygon and the index of a vertex, check if that vertex is the "middle"
# vertex of a ear. It is a ear if no point of the polygon is inside 
# the triangle formed by the vertex and its two neighbours.
check_if_vertex_makes_ear = (input_polygon, vertex_index) ->

  a = input_polygon[(vertex_index - 1) %% input_polygon.length]
  b = input_polygon[vertex_index]
  c = input_polygon[(vertex_index + 1) %% input_polygon.length]

  if simple_polygon_orientation_clockwise(input_polygon) 
    if orientation_test(a, b, c) >= 0
      return false
  else 
    if orientation_test(a, b, c) <= 0
      return false

  for i in [0...input_polygon.length]
    if (i != vertex_index) and (i != (vertex_index - 1) %% input_polygon.length) and (i != (vertex_index + 1) %% input_polygon.length) and
      point_inside_triangle(a, b, c, input_polygon[i])
        return false
  return true

###################################
# TRIANGLE DECOMPOSITION ##########
# Decompose the given simple polygon in triangles, 
# and return the list of triangles that compose the polygon
triangle_decomposition = (input_polygon) ->
  polygon = input_polygon.slice()

  i = 0
  triangles = []
  while polygon.length > 3
    ear_found = check_if_vertex_makes_ear(polygon, i)
    if ear_found
      triangles.push([polygon[(i - 1) %% polygon.length], polygon[(i + 1) %% polygon.length], polygon[i]])
      polygon.splice(i, 1)
      i = 0
    else
      i++
  triangles.push([polygon[(-1) %% polygon.length], polygon[(1) %% polygon.length], polygon[0]])
  return triangles


###################################
# TRIANGLE DECOMPOSITION RECURSIVE
# Decompose the given simple polygon in triangles, 
# and return the list of triangles that compose the polygon
triangle_decomposition_recursive = (input_polygon, triangles) ->
  polygon = input_polygon.slice()

  if polygon.length <= 3
    triangles.push([polygon[(-1) %% polygon.length], polygon[(1) %% polygon.length], polygon[0]])
    return triangles
  else
    for i in [0..polygon.length]
      ear_found = check_if_vertex_makes_ear(polygon, i)
      if ear_found
        triangles.push([polygon[(i - 1) %% polygon.length], polygon[(i + 1) %% polygon.length], polygon[i]])
        polygon.splice(i, 1)
        return triangle_decomposition_recursive(polygon, triangles)
        