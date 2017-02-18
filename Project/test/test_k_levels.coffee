# input_points = [
#   new Point(2, -2),
#   new Point(-0.8, 4.2),
#   new Point(1, 3),
#   new Point(0.1, 0.6),
#   new Point(0.4, 1.2),
#   new Point(-0.2, 2.2),
#   new Point(1.4, 0.3),
#   new Point(-0.3, 4.8),
#   new Point(-0.2, 6),
#   new Point(3, -10)
# ]

input_points = [
  new Point(100, 10),
  new Point(300, 200), 
  new Point(423, 200), 
  new Point(100, 300), 
  new Point(500, 120), 
  new Point(200, 320),
  new Point(50, 40),
  new Point(51, 350), 
  new Point(150, 350),
  new Point(220, 400),
  new Point(240, 320), 
  new Point(280, 450)]


default_color = [121, 204, 147, 200]

num_input_points = 15

# Input points need to be rescaled to have dual lines that can be visualized.
# The scale factor says by how much each coordinate is divided.
scale_factor = 1

w = 1200
h = 700

dual_lines = []

k = 5

k_level_u = []
reflex_vertices_u = []
zonoid_vertices_u = []

k_level_d = []
reflex_vertices_d = []
zonoid_vertices_d = []

zonoid_lines = []


zonoid = []


setup = () ->
  createCanvas(w, h)
  fill('red')   
  frameRate(10)


  for p in input_points
    dual_lines.push(create_line_from_m_q(p.x, p.y * scale_factor))

  k_level_u = compute_k_level(dual_lines, k)
  reflex_vertices_u = compute_reflex_vertices(k_level_u, up:true)
  zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, up:true)

  k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1)
  reflex_vertices_d = compute_reflex_vertices(k_level_d, up:false)
  zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, up:false)

  zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d)
  for p_i in zonoid_dual_vertices
    zonoid_lines.push(new Line(new Point(-10000, p_i.x * -10000 + p_i.y), new Point(10000, p_i.x * 10000 + p_i.y), p_i.x, p_i.y))

  

draw = () -> 
  background(255, 251, 234)

  fill("black");
  stroke("black");

  for l in dual_lines
    stroke(default_color)
    strokeWeight(2)
    line(l.start.x, l.start.y, l.end.x, l.end.y)

  # DRAW K-LEVEL UPPER   
  fill(143, 27, 10, 200)  
  stroke(231, 120, 58, 200);
  for i in [1..k_level_u.length - 1]
    strokeWeight(6)
    line(k_level_u[i - 1].x, k_level_u[i - 1].y, k_level_u[i].x, k_level_u[i].y)
  strokeWeight(1)

  # DRAW REFLEX VERTICES UPPER
  for p in reflex_vertices_u
    fill(143, 27, 10, 200)  
    stroke(231, 120, 58, 200);
    ellipse(p.x, p.y, 20, 20)

    y = p.y - 15
    fill(default_color)  
    stroke(default_color) 
    strokeWeight(2)
    while y > 0
      ellipse(p.x, y, 2, 2)
      y -= 10
    
  # DRAW ZONOID UPPER  
  fill(143, 27, 10, 200)  
  stroke(231, 120, 58, 200);
  strokeWeight(6)
  if zonoid_vertices_u.length > 1
    for i in [1..zonoid_vertices_u.length - 1]
      line(zonoid_vertices_u[i - 1].x, zonoid_vertices_u[i - 1].y, zonoid_vertices_u[i].x, zonoid_vertices_u[i].y)
  strokeWeight(2)
  for p in zonoid_vertices_u
    ellipse(p.x, p.y, 20, 20)




  # DRAW K-LEVEL LOWER   
  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200); 
  for i in [1..k_level_d.length - 1]
    strokeWeight(6)
    line(k_level_d[i - 1].x, k_level_d[i - 1].y, k_level_d[i].x, k_level_d[i].y)
  strokeWeight(2)


  # DRAW REFLEX VERTICES UPPER
  for p in reflex_vertices_d
    fill(98, 122, 161, 200)  
    stroke(21, 32, 50, 200); 
    ellipse(p.x, p.y, 20, 20)

    y = p.y + 15
    fill(default_color)  
    stroke(default_color) 
    strokeWeight(2)
    while y < h
      ellipse(p.x, y, 2, 2)
      y += 10

  # DRAW ZONOID LOWER  
  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200); 
  strokeWeight(6)
  if zonoid_vertices_d.length > 1
    for i in [1..zonoid_vertices_d.length - 1]
      line(zonoid_vertices_d[i - 1].x, zonoid_vertices_d[i - 1].y, zonoid_vertices_d[i].x, zonoid_vertices_d[i].y)
  strokeWeight(2)
  for p in zonoid_vertices_d
    ellipse(p.x, p.y, 20, 20)
  # if zonoid_vertices_u.length > 1
  #   leftmost_u = leftmost_point(zonoid_vertices_u)
  #   rightmost_u = rightmost_point(zonoid_vertices_u)
  #   zonoid_slice_u = zonoid_vertices_u.slice()
  #   zonoid_slice_u.push(new Point(leftmost_u.x, h))
  #   zonoid_slice_u.push(new Point(rightmost_u.x, h))
  #   draw_poly(radial_sort(zonoid_slice_u, anchor: leftmost_point(zonoid_slice_u), cw: true), fill_color:[16, 74, 34, 100], stroke_color:[16, 74, 34, 255])


  for l_i in zonoid_lines
    line(l_i.start.x + 500, l_i.start.y, l_i.end.x + 500, l_i.end.y)


  for z_i in zonoid
    fill(16, 74, 34, 180)
    stroke(16, 74, 34, 255)
    ellipse(z_i.x, z_i.y, 20, 20)
    ellipse(z_i.x, z_i.y, 10, 10)
  if zonoid.length > 0
    draw_poly(radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true))
    draw_poly(zonoid, fill_color:[78, 185, 120, 160], stroke_color:[16, 74, 34, 255])


mouseWheel = (event) ->
  if event.delta > 0
    k -= 1
  else if event.delta < 0
    k += 1
  if k < 1
    k = 1
  if k > dual_lines.length
    k = dual_lines.length
  k_level_u = compute_k_level(dual_lines, k)
  reflex_vertices_u = compute_reflex_vertices(k_level_u, up:true)
  zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, up:true)

  k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1)
  reflex_vertices_d = compute_reflex_vertices(k_level_d, up:false)
  zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, up:false)

  zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d)
  zonoid_lines = []
  for p_i in zonoid_dual_vertices
    zonoid_lines.push(new Line(new Point(-10000, p_i.x * -10000 + p_i.y), new Point(10000, p_i.x * 10000 + p_i.y), p_i.x, p_i.y))

  zonoid = compute_zonoid(input_points, k:(k - 1))
  console.log "K: ", k
    

draw_poly = (points, {fill_color, stroke_color} = {}) ->

  fill_color ?= default_color
  stroke_color ?= default_color
  fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3])
  stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3])
  beginShape()
  for p_i in points 
    vertex(p_i.x, p_i.y)
  endShape(CLOSE)
   


leftmost_point = (S) ->
  leftmost_p = S[0]
  for p in S[1..S.length - 1]
   if p.x < leftmost_p.x 
    leftmost_p = p 
  return leftmost_p


rightmost_point = (S) ->
  rightmost_p = S[0]
  for p in S[1..S.length - 1]
   if p.x > rightmost_p.x 
    rightmost_p = p 
  return rightmost_p

