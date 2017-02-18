###################################
# UTILITIES #######################
###################################


# Size of the canvas
w= 640
h = 480

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

class Line 
    constructor: (@start, @end, @m, @q) ->

    toString: -> 
      return "Line( start: " + @start + " -- end: " + @end + " -- m: " + @m + " -- q: " + @q + ")\n"

class KSetElem extends Point
    constructor: (@x, @y, @weight) ->
        super(@x, @y)
    
    toString: ->
        return "KSetElem(" + this.x + ", " + this.y + ", -- weight: " + this.weight +")\n"

class KSet 
    constructor: () ->
      @elem_list = []
      @mean_point = new Point(0, 0)
      @separator = [new Point(0, 0), new Point(0, 0)]
      
    compute_mean: ->
        for p in @elem_list
            @mean_point.x += p.x
            @mean_point.y += p.y
        @mean_point.x /= @elem_list.length
        @mean_point.y /= @elem_list.length

    toString: ->
        return "KSet(" + this.elem_list + "\n" + "MEAN: " + this.mean_point + ", -- separator: " + this.separator[0] + ", " + this.separator[1] + ")\n" 

a = new KSet
console.log a.separator


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
# RADIAL SORT #####################
###################################
# Sort clockwise (or counter-clockwise) a list of points w.r.t. a given anchor point.
# If the points, translated w.r.t. the anchor, span multiple quadrants of the plane,
# they are sorted by taking the positive x semi-axis as starting point.
# Inspired by "http://stackoverflow.com/questions/6989100/sort-points-in-clockwise-order"
radial_sort = (points, {anchor, cw} = {}) ->
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



###################################
# Given the parameters m, q, 
# return a line y = m * x + q 
# spanning the entire canvas.
create_line_from_m_q = (m, q) ->
  # Numerical approximation
  if Math.abs(q) <= 0.1
    q = 0

  if m == 0
    return new Line(new Point(0, q), new Point(w, q), m, q)
  # Find the two extreme points of the line.
  start_y = q
  end_y = m * w + q 

  if start_y >= 0 and start_y <= h 
    
    if end_y >= 0 and end_y <= h
      return new Line(new Point(0, start_y), new Point(w, end_y), m, q)
    else if end_y < 0
      return new Line(new Point(0, start_y), new Point(-q / (m + epsilon), 0), m, q)
    else
      return new Line(new Point(0, start_y), new Point((h-q) / (m + epsilon), h), m, q)

  if start_y < 0

    if end_y >= 0 and end_y <= h
      return new Line(new Point(-q / (m + epsilon), 0), new Point(w, end_y), m, q)
    else if end_y > 0
      return new Line(new Point(-q / (m + epsilon), 0), new Point((h-q) / (m + epsilon), h), m, q)
    else   
      console.log "ERROR!"
    
  else

    if end_y >= 0 and end_y <= h
      return new Line(new Point((h-q) / (m + epsilon), h), new Point(w, end_y), m, q)
    else if end_y < 0
      return new Line(new Point((h-q) / (m + epsilon), h), new Point(-q / (m + epsilon), 0), m, q)
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
    lines.push(create_line(new Point(l.start.x - point.x, l.start.y - point.y), new Point(l.end.x - point.x, l.end.y - point.y)))

  return lines



###################################
# Given a set of lines and a point
# which is currently the origin, 
# translate the lines back.
translate_back = (input_lines, point) ->
  lines = []
  for l in input_lines
    lines.push(create_line(new Point(l.start.x + point.x, l.start.y + point.y), new Point(l.end.x + point.x, l.end.y + point.y)))

  return lines


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