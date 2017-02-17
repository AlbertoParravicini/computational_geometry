input_points = [
  new Point(2, -2),
  new Point(-0.8, 4.2),
  new Point(1, 3),
  new Point(0.1, 0.6),
  new Point(0.4, 1.2),
  new Point(-0.2, 2.2),
  new Point(1.4, 0.3),
  new Point(-0.3, 4.8),
]
  # new Point(100, 10), 
  # new Point(300, 200), 
  # new Point(423, 200),
  # new Point(100, 300), 
  # new Point(500, 120), 
  # new Point(200, 320), 
  # new Point(50, 40),
  # new Point(51, 350),
  # new Point(150, 350),
  # new Point(220, 400),
  # new Point(240, 320), 
  # new Point(280, 450)]

default_color = [121, 204, 147, 200]

num_input_points = 15

# Input points need to be rescaled to have dual lines that can be visualized.
# The scale factor says by how much each coordinate is divided.
scale_factor = 100

h = 480
w = 1200

dual_lines = []

k = 5
k_level = []

reflex_vertices = []
zonoid_vertices = []

setup = () ->
  createCanvas(w, h)
  fill('red')   
  frameRate(10)


  for p in input_points
    dual_lines.push(create_line_from_m_q(p.x, p.y * scale_factor))

  k_level = compute_k_level(dual_lines, k)
  reflex_vertices = compute_reflex_vertices(k_level)
  zonoid_vertices = compute_zonoid_vertices_from_reflex(reflex_vertices, dual_lines)
  console.log k_level



draw = () -> 
  background(255, 251, 234)

  fill("black");
  stroke("black");

  for l in dual_lines
    stroke(default_color)
    strokeWeight(2)
    line(l.start.x, l.start.y, l.end.x, l.end.y)
    
  fill(143, 27, 10, 200)  
  stroke(231, 120, 58, 200);
  for p in k_level[1..k_level.length - 1]
    ellipse(p.x, p.y, 20, 20)
  for i in [1..k_level.length - 1]
    strokeWeight(6)
    line(k_level[i - 1].x, k_level[i - 1].y, k_level[i].x, k_level[i].y)
  strokeWeight(1)

  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200);
  for p in reflex_vertices
    ellipse(p.x, p.y, 20, 20)

  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200);
  for p in zonoid_vertices
    ellipse(p.x, p.y, 20, 20)

  draw_poly(radial_sort(zonoid_vertices, anchor: leftmost_point(zonoid_vertices), cw: true), fill_color:[16, 74, 34, 100], stroke_color:[16, 74, 34, 255])



mouseWheel = (event) ->
  if event.delta > 0
    k -= 1
  else if event.delta < 0
    k += 1
  if k < 1
    k = 1
  if k > dual_lines.length
    k = dual_lines.length
  k_level = compute_k_level(dual_lines, k)
  reflex_vertices = compute_reflex_vertices(k_level)
  zonoid_vertices = compute_zonoid_vertices_from_reflex(reflex_vertices, dual_lines)
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
