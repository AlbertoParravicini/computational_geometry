###################################
# UTILITIES #######################
###################################

class Point
    x: 0.0
    y: 0.0
    constructor: (@x, @y) ->

    toString: ->
        return "Point(" + this.x + ", " + this.y + ")\n"

class KSetElem extends Point
    constructor: (@x, @y, @weight) ->
        super(@x, @y)
    
    toString: ->
        return "KSetElem(" + this.x + ", " + this.y + ", -- weight: " + this.weight +")\n"




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