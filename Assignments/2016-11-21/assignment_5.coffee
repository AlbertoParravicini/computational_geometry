###################################
# UTILITIES #######################
###################################

class Point
  x: 0.0
  y: 0.0
  constructor: (@x, @y) ->
  toString: ->
    return "x: " + this.x + " - y: " + this.y

class PointEdge
  constructor: (@x, @y, @edge) ->
    @start = false
    @edge = null
  toString: ->
    return "x: " + this.x + " - y: " + this.y + " - start: " + this.start + "\n"

class PointIntersection
  constructor: (@x, @y, @edge_1, @edge_2) ->
  toString: ->
    return "x: " + this.x + " - y: " + this.y + " - edge_1: " + this.edge_1 + " - edge_1: " + this.edge_2 + "\n"


class Edge 
  constructor: (input_p1, input_p2) ->
    @start_point = null
    @end_point = null
    if input_p1 != null and input_p2 !=null
      if input_p1.x < input_p2.x 
        this.start_point = input_p1
        this.start_point.start = true
        this.end_point = input_p2
      else 
        this.start_point = input_p2
        this.start_point.start = true
        this.end_point = input_p1
      this.start_point.edge = this
      this.end_point.edge = this
  toString: ->
    return "start " + this.start_point.toString() + " - end: " + this.end_point.toString() + "\n"


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
# BINARY SEARCH TREE ##############
###################################
# Inspired by 
# https://github.com/nzakas/computer-science-in-javascript/blob/master/data-structures/binary-search-tree/binary-search-tree.js

class Node
  constructor: (value) ->
    @value = value
    @left = null
    @right = null
    @parent = null

class BinarySearchTree

  constructor: (compare_function) ->
    @root = null   
    @compare = if !compare_function 
                (a, b) ->
                    if a > b 
                      return 1
                    else if a < b 
                      return -1 
                    else return 0
               else compare_function

  insert: (value) ->
    node = new Node(value)
    current = null

    if this.root == null
      this.root = node
    else 
      current = this.root

      loop
        if this.compare(value, current.value) < 0 #value < current.value 
          if current.left == null
            current.left = node
            node.parent = current
            break
          else  
            current = current.left
        else if this.compare(value, current.value) > 0 #value > current.value
          if current.right == null
            current.right = node
            node.parent = current
            break
          else 
            current = current.right
        else break


  search: (value) -> 
    found = false
    current = this.root

    while(!found and current)
      if this.compare(value, current.value) < 0 #value < current.value 
        current = current.left
      else if this.compare(value, current.value) > 0 #value > current.value
        current = current.right
      else  
        found = true
    return found


  remove: (value) -> 
    found = false
    parent = null
    current = this.root
    child_count = 0
    replacement = null
    replacement_parent = null

    while !found and current
      if this.compare(value, current.value) < 0 # value < node.value
        parent = current
        current = current.left
      else if this.compare(value, current.value) > 0 # value > node.value
        parent = current
        current = current.right
      else 
        found = true
    #
    
    if found
      #parent = current.parent
      child_count = (if current.left != null then 1 else 0) + (if current.right != null then 1 else 0)
      if current == this.root

        if child_count == 0
          this.root = null

        else if child_count == 1
          this.root = if current.right == null then current.left else current.right
        
        else
          replacement = this.root.left

          while replacement.right != null
            replacement_parent = replacement
            replacement = replacement.right

          if replacement_parent != null
            replacement_parent.right = replacement.left

            replacement.right = this.root.right
            replacement.left = this.root.left
            replacement.left.parent = this.left
          else
            replacement.right = this.root.right
            replacement.right.parent = this.root
          this.root = replacement  
      else
        if child_count == 0
          if this.compare(value, parent.value) < 0 # value < node.value 
            parent.left = null
          else parent.right = null

        if child_count == 1
          if this.compare(value, parent.value) < 0 # value < node.value
            parent.left = if current.left == null then current.right else current.left
            #
            parent.left.parent = parent
          else 
            parent.right = if current.left == null then current.right else current.left
            #
            parent.right.parent = parent

        if child_count == 2
          replacement = current.left
          replacement_parent = current

          while replacement.right != null
            replacement_parent = replacement
            replacement = replacement.right

          replacement_parent.right = replacement.left

          replacement.right = current.right
          replacement.left = current.left

          if this.compare(current.value, parent.value) < 0 # value < node.value 
            parent.left = replacement
            #
            replacement.parent = parent
          else
            parent.right = replacement
            #
            replacement.parent = parent

  #Inspired by http://algorithms.tutorialhorizon.com/inorder-predecessor-and-successor-in-binary-search-tree/
  predecessor: (value, root, pred) ->
    if root != null and root != undefined
      if root.value == value
        if root.left != null 
          current = root.left
          while current.right != null
            current = current.right
          pred = current.value
        return pred
      else if this.compare(value, root.value) < 0 # value < root.value
        this.predecessor(value, root.left, pred)
      else  
        pred = root.value
        this.predecessor(value, root.right, pred)       
    else 
      return pred

  successor: (value, root, succ) ->
    if root != null and root != undefined
      if root.value == value
        if root.right != null 
          current = root.right
          while current.left != null
            current = current.left
          succ = current.value
        return succ
      else if this.compare(value, root.value) < 0 # value < root.value
        succ = root.value
        this.successor(value, root.left, succ)
      else     
        this.successor(value, root.right, succ)       
    else 
      return succ
  
  # Helper function to traverse the tree in-order
  traverse: (process) ->
    in_order = (node) ->
      if node    
        if node.left != null 
          in_order(node.left)
        
        process.call(this, node)

        if node.right != null 
          in_order(node.right)
    #Start from the root of the tree
    in_order(this.root)

  size: -> 
    length = 0
    this.traverse((node) ->
      length++
    )
    return length

  to_array: -> 
    result = []
    this.traverse((node) ->
      result.push(node.value)
    )
    return result

  toString: ->
    return this.to_array().toString()

  
# Test bst

points = [
  1, 3, 8, 10, 15, 34, 6, 9, 2
]


compare_y = (a, b) ->
  if a.y > b.y
    return 1
  else if a.y < b.y
    return -1 
  else return 0
tree = new BinarySearchTree()


for i in points
  tree.insert(i)
console.log tree.size()
console.log tree.predecessor(11, tree.root)
console.log tree.predecessor(1, tree.root)

points = [
  new Point(2, 5),
  new Point(10, 7),
  new Point(3, 4),
  new Point(8, 5),
  new Point(6, 3),
  new Point(4, 8),
  new Point(11, 4),
  new Point(5, 1),
  new Point(9, 10),
  new Point(12, 9),
  new Point(7.1, 1),
  new Point(7.3, 7)
]


i = 0
edges_points = []
while i < points.length
  p1 = new PointEdge(points[i].x, points[i].y)
  p2 = new PointEdge(points[i + 1].x, points[i + 1].y)
  temp_edge = new Edge(p1, p2)
  edges_points.push(p1, p2)
  i += 2

# console.log "input: ", edges_points
# edges_points.sort((a, b) ->
#             if a.x > b.x
#               return 1
#             else if a.x < b.x
#               return -1
#             else return 0
#             )

# # console.log "\n\nsorted: ", edges_points


# # console.log "\n\nother tests"
# # console.log edges_points[2].edge.end_point
# # console.log edges_points[2].edge.end_point == edges_points[4]

# console.log "\n\ntesting tree\n"
# for p in edges_points
#   if p.start 
#     tree.insert(p)
#     console.log "inserted:", p
#   else
#     tree.remove(p.edge.start_point)
#     console.log "removed", p.edge.start_point
#   console.log "tree_size: ", tree.size()


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
# ASSIGNMENT 5 ####################
###################################

###################################
# CHECK LINE INTERSECTION #########
###################################
# Check if the 2 segments intersect.
check_intersection = (edge_1, edge_2) ->
  if edge_1 == null or edge_1 == undefined or edge_2 == null or edge_2 == undefined
    return false
  
  o1 = orientation_test(edge_1.start_point, edge_1.end_point, edge_2.start_point)
  o2 = orientation_test(edge_1.start_point, edge_1.end_point, edge_2.end_point)

  o3 = orientation_test(edge_2.start_point, edge_2.end_point, edge_1.start_point)
  o4 = orientation_test(edge_2.start_point, edge_2.end_point, edge_1.end_point)

  # We have an intersection.
  if o1 * o2 < 0 and o3 * o4 < 0
    m1 = (edge_1.end_point.y - edge_1.start_point.y) / (edge_1.end_point.x - edge_1.start_point.x)
    m2 = (edge_2.end_point.y - edge_2.start_point.y) / (edge_2.end_point.x - edge_2.start_point.x)
    q1 = (edge_1.start_point.y * edge_1.end_point.x - edge_1.end_point.y * edge_1.start_point.x) / (edge_1.end_point.x - edge_1.start_point.x)
    q2 = (edge_2.start_point.y * edge_2.end_point.x - edge_2.end_point.y * edge_2.start_point.x) / (edge_2.end_point.x - edge_2.start_point.x)
    x = (q2 - q1) / (m1 - m2)
    y = (m1 * q2 - m2 * q1) / (m1 - m2)

    if edge_2.end_point.y > edge_1.end_point.y
      return new PointIntersection(x, y, edge_2, edge_1)
    else
      return new PointIntersection(x, y, edge_1, edge_2)
  return false


check_list = (list, point) ->
  for p in list
    if p.x == point.x and p.y == point.y
      return true
  return false
  

###################################
# SWEEP LINE INTERSECTION #########
###################################
# Inspired by 
# https://github.com/nzakas/computer-science-in-javascript/blob/master/data-structures/binary-search-tree/binary-search-tree.js
sweep_line_intersection = (input_edges) ->
  points = input_edges.slice()
  intersections = []

  # Sort the points by x coordinate
  points.sort((a, b) ->
            if a.x > b.x
              return 1
            else if a.x < b.x
              return -1
            else return 0
            )

  compare_y = (a, b) ->
    if a.y > b.y
      return 1
    else if a.y < b.y
      return -1 
    else return 0
  sweep_line = new BinarySearchTree(compare_y)
  
  num_of_intersections = 0
  # Process all points
  while points.length > 0
    point = points[0]
    console.log points.length
   
    if point instanceof PointEdge and point.start
      sweep_line.insert(point)
      pred = sweep_line.predecessor(point, sweep_line.root)
      succ = sweep_line.successor(point, sweep_line.root) 
      
      if pred != null and pred != undefined     
        intersection = check_intersection(point.edge, pred.edge)
        if intersection
          # TODO: Sorted Insertion!
          points.push(intersection)
          points.sort((a, b) ->
            if a.x > b.x
              return 1
            else if a.x < b.x
              return -1
            else return 0
          )
            
          
      if succ != null and succ != undefined
        intersection = check_intersection(point.edge, succ.edge)
        if intersection
          # TODO: Sorted Insertion!
          points.push(intersection)
          points.sort((a, b) ->
            if a.x > b.x
              return 1
            else if a.x < b.x
              return -1
            else return 0
          )
          

    else if point instanceof PointEdge and !point.start
      pred = sweep_line.predecessor(point, sweep_line.root)
      succ = sweep_line.successor(point, sweep_line.root) 
      sweep_line.remove(point.edge.start_point)
      sweep_line.remove(point.edge.end_point)

      if pred != null and succ != null and pred != undefined and succ != undefined
        intersection = check_intersection(pred.edge, succ.edge)
        if intersection 
          # TODO: Sorted Insertion!
          # TODO: check if already present
          if !check_list(points, intersection)
            points.push(intersection)
            points.sort((a, b) ->
              if a.x > b.x
                return 1
              else if a.x < b.x
                return -1
              else return 0
            )  

    else # intersection
      intersections.push(point)
      edge_1 = point.edge_1
      edge_2 = point.edge_2
      console.log "CHECK: ", edge_1.end_point.y > edge_2.end_point.y
      # temp_a = sweep_line.successor(edge_2.start_point, sweep_line.root)
      # if temp_a
      #   seg_a = sweep_line.successor(temp_a, sweep_line.root)
      # temp_b = sweep_line.predecessor(edge_1.start_point, sweep_line.root)
      # if temp_b
      #   seg_b = sweep_line.predecessor(temp_b, sweep_line.root)

      # seg_a = sweep_line.successor(edge_2.end_point, sweep_line.root)
      # seg_b = sweep_line.predecessor(edge_1.end_point, sweep_line.root)

      if seg_a != null and seg_a != undefined
        intersection = check_intersection(edge_2, seg_a.edge)
        if intersection
          if !check_list(points, intersection)
            points.push(intersection)
            points.sort((a, b) ->
              if a.x > b.x
                return 1
              else if a.x < b.x
                return -1
              else return 0
            )

      if seg_b != null and seg_b != undefined
        intersection = check_intersection(edge_1, seg_b.edge)
        if intersection
          if !check_list(points, intersection)
            points.push(intersection)
            points.sort((a, b) ->
              if a.x > b.x
                return 1
              else if a.x < b.x
                return -1
              else return 0
            ) 
    points.splice(0,1)
  return intersections

console.log edges_points
console.log "\nINT:", sweep_line_intersection(edges_points)