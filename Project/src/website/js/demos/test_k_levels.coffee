
input_points = [
  new Point(0.31, 3),
  new Point(0.1, 0.6),
  new Point(0.4, 1.2),
  new Point(-0.4, 4.2),
  new Point(-0.3, 5),
  new Point(0.9, 0.3),
  new Point(0.8, -0.6),
  new Point(-0.8, 6),
  new Point(0.05, 2)
]



# input_points = [
#   new Point(100, 10),
#   new Point(300, 200), 
#   new Point(423, 200), 
#   new Point(100, 300), 
#   new Point(500, 120), 
#   new Point(200, 320),
#   new Point(50, 40),
#   new Point(51, 350), 
#   new Point(150, 350),
#   new Point(220, 400),
#   new Point(240, 320), 
#   new Point(280, 450)
# ]


default_color = [121, 204, 147, 200]

num_input_points = 15

# Input points need to be rescaled to have dual lines that can be visualized.
# The scale factor says by how much each coordinate is divided.
scale_factor = 80

w = 1400
h = 600

# Size of half axis in the original canvas
canvas_bound_original = 5


dual_lines = []

k = 1

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
  frameRate(3)
  console.log "K:", k


  for p in input_points
    dual_lines.push(create_line_from_m_q(p.x, p.y))
  

  k_level_u = compute_k_level(dual_lines, k, reverse:true)
  reflex_vertices_u = compute_reflex_vertices(k_level_u, up:false)
  zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, up:false)

  k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1, reverse:true)
  reflex_vertices_d = compute_reflex_vertices(k_level_d, up:true)
  zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, up:true)

  zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d)
  for p_i in zonoid_dual_vertices
    zonoid_lines.push(new Line(new Point(-10000, -p_i.x * -10000 + p_i.y), new Point(10000, -p_i.x * 10000 + p_i.y), -p_i.x, p_i.y))


  zonoid = compute_zonoid(input_points, k:k-1)
  console.log "K: ", k
    
draw = () -> 
  background(255, 251, 234)

  fill("black");
  stroke("black");


  for l in dual_lines.map((l) -> return [
      new Point(l.start.x * scale_factor, l.start.y * scale_factor),
      new Point(l.end.x * scale_factor, l.end.y * scale_factor)
      ])
    stroke(default_color)
    strokeWeight(2)
    line(l[0].x, l[0].y, l[1].x, l[1].y)


  # # DRAW K-LEVEL UPPER   
  fill(143, 27, 10, 200)  
  stroke(231, 120, 58, 200)
  k_level_u_temp = k_level_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
  for i in [1..k_level_u.length - 1]
    strokeWeight(6)
    
    line(k_level_u_temp[i - 1].x, k_level_u_temp[i - 1].y, k_level_u_temp[i].x, k_level_u_temp[i].y)
  strokeWeight(1)

  # DRAW REFLEX VERTICES UPPER
  for p in reflex_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    fill(143, 27, 10, 200)  
    stroke(231, 120, 58, 200)
    ellipse(p.x, p.y, 20, 20)

    y = p.y + 15
    fill(default_color)  
    stroke(default_color) 
    strokeWeight(2)
    while y < h
      ellipse(p.x, y, 2, 2)
      y += 10
    
  # DRAW ZONOID UPPER  
  fill(143, 27, 10, 200)  
  stroke(231, 120, 58, 200);
  strokeWeight(6)
  zonoid_vertices_u_temp = zonoid_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
  if zonoid_vertices_u_temp.length > 1
    for i in [1..zonoid_vertices_u_temp.length - 1]
      line(zonoid_vertices_u_temp[i - 1].x, zonoid_vertices_u_temp[i - 1].y, zonoid_vertices_u_temp[i].x, zonoid_vertices_u_temp[i].y)
  strokeWeight(2)
  for p in zonoid_vertices_u_temp
    ellipse(p.x, p.y, 20, 20)

  if zonoid_vertices_u_temp.length > 1
    for i in [1..zonoid_vertices_u_temp.length - 1]
      zonoid_slice_u = [zonoid_vertices_u_temp[i - 1], zonoid_vertices_u_temp[i], new Point(zonoid_vertices_u_temp[i].x, 10000), new Point(zonoid_vertices_u_temp[i - 1].x, 10000)]
      draw_poly(zonoid_slice_u, fill_color:[231, 120, 58, 40], stroke_color:[16, 74, 34, 0])



  # # DRAW K-LEVEL LOWER   
  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200); 
  k_level_d_temp = k_level_d.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
  for i in [1..k_level_d_temp.length - 1]
    strokeWeight(6)
    line(k_level_d_temp[i - 1].x, k_level_d_temp[i - 1].y, k_level_d_temp[i].x, k_level_d_temp[i].y)
  strokeWeight(2)


  # # DRAW REFLEX VERTICES LOWER
  for p in reflex_vertices_d.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    fill(98, 122, 161, 200)  
    stroke(21, 32, 50, 200); 
    ellipse(p.x, p.y, 20, 20)

    y = p.y - 15
    fill(default_color)  
    stroke(default_color) 
    strokeWeight(2)
    while y > 0
      ellipse(p.x, y, 2, 2)
      y -= 10

  # # DRAW ZONOID LOWER  
  fill(98, 122, 161, 200)  
  stroke(21, 32, 50, 200); 
  strokeWeight(6)
  zonoid_vertices_d_temp = zonoid_vertices_d.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
  if zonoid_vertices_d_temp.length > 1
    for i in [1..zonoid_vertices_d_temp.length - 1]
      line(zonoid_vertices_d_temp[i - 1].x, zonoid_vertices_d_temp[i - 1].y, zonoid_vertices_d_temp[i].x, zonoid_vertices_d_temp[i].y)
  strokeWeight(2)
  for p in zonoid_vertices_d_temp
    ellipse(p.x, p.y, 20, 20)

  
  if zonoid_vertices_d_temp.length > 1
    for i in [1..zonoid_vertices_d_temp.length - 1]
      zonoid_slice_d = [zonoid_vertices_d_temp[i - 1], zonoid_vertices_d_temp[i], new Point(zonoid_vertices_d_temp[i].x, -10000), new Point(zonoid_vertices_d_temp[i - 1].x, -10000)]
      draw_poly(zonoid_slice_d, fill_color:[21, 32, 50, 40], stroke_color:[16, 74, 34, 0])


  # DRAW THE PRIMAL ON THE RIGHT SIDE
  draw_poly([new Point(w / 2, 0), new Point(w, 0), new Point(w, h), new Point(w / 2, h)], fill_color:[255, 251, 234, 255], stroke_color:[0,0,0,0])
  stroke(143, 114, 93, 120)
  strokeWeight(6)
  line(w / 2, 0, w / 2, h)
  stroke("black")
  strokeWeight(1)

  fill(85, 185, 102, 60);
  stroke(17, 74, 27, 180);
  for p in input_points.map((p) -> return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100))
    ellipse(p.x, p.y, 10, 10)
  stroke(143, 114, 93, 200)
  # DRAW ZONOID BASED ON THE DUAL REFLEX VERTICES
  for l_i in zonoid_lines.map((l) -> return [
      new Point(l.start.x * (scale_factor * 2) + w * 0.75, l.start.y * scale_factor + 100),
      new Point(l.end.x * (scale_factor * 2) + w * 0.75, l.end.y * scale_factor + 100)
      ])
    line(l_i[0].x, l_i[0].y, l_i[1].x, l_i[1].y)

  #DRAW ZONOID BASED ON THE DUAL LINES
  # if zonoid_vertices_u.length > 1 and zonoid_vertices_d.length > 1
  #   for i in [1..zonoid_vertices_u.length - 1]
  #     [m, q] = compute_m_q_of_line(zonoid_vertices_u[i - 1], zonoid_vertices_u[i])
  #     ellipse(m * (scale_factor * 2) + w * 0.75, q * scale_factor + 100, 20, 20)

  #   for i in [1..zonoid_vertices_d.length - 1]
  #     [m, q] = compute_m_q_of_line(zonoid_vertices_d[i - 1], zonoid_vertices_d[i])
  #     ellipse(m * (scale_factor * 2) + w * 0.75, q * scale_factor + 100, 20, 20)
  
  #DRAW THE ZONOID COMPUTED THROUGH KSETS
  zonoid_temp = zonoid.map((p) -> return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100))
  for z_i in zonoid_temp
    fill(16, 74, 34, 180)
    stroke(16, 74, 34, 255)
    ellipse(z_i.x, z_i.y, 20, 20)
    ellipse(z_i.x, z_i.y, 10, 10)
  if zonoid_temp.length > 0
    draw_poly(radial_sort(zonoid_temp, anchor: leftmost_point(zonoid_temp), cw: true), fill_color:[78, 185, 120, 160], stroke_color:[16, 74, 34, 255])



mouseWheel = (event) ->
  if event.delta > 0
    k -= 1
  else if event.delta < 0
    k += 1
  if k < 2
    k = 1
  if k > dual_lines.length 
    k = dual_lines.length 
  k_level_u = compute_k_level(dual_lines, k, reverse:true)
  reflex_vertices_u = compute_reflex_vertices(k_level_u, up:false)
  zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, up:false)

  k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1, reverse:true)
  reflex_vertices_d = compute_reflex_vertices(k_level_d, up:true)
  zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, up:true)

  zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d)
  zonoid_lines = []
  for p_i in zonoid_dual_vertices
    zonoid_lines.push(new Line(new Point(-10000, -p_i.x * -10000 + p_i.y), new Point(10000, -p_i.x * 10000 + p_i.y), -p_i.x, p_i.y))

  zonoid = compute_zonoid(input_points, k:k-1)
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
  fill("black")
  stroke("black")
   


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


