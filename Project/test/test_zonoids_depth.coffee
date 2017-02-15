input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
    new Point(200, 320), new Point(50, 40),new Point(51, 350), new Point(150, 350),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];


num_input_points =  14

query_point = false

default_color = [121, 204, 147, 40]


h = 480
w = 640

# for i in [0..num_input_points - 1]
#   input_points.push(new Point(Math.floor(Math.random() * w), Math.floor(Math.random() * h)))

zonoid = []

zonoid_list = []

for i in [1..input_points.length]
  zonoid_list.push(compute_zonoid(input_points, k:i, discrete:true))

setup = () ->
  createCanvas(w, h)
  fill('black')   

draw = () -> 
  background(255, 251, 234)

  fill(118, 198, 222);
  stroke(118, 198, 222);

  for p_i in input_points
    ellipse(p_i.x, p_i.y, 6, 6)



  
  for zonoid_i in zonoid_list
    for z_i in zonoid_i
      fill(16, 74, 34, 60)
      stroke(16, 74, 34, 255)
      ellipse(z_i.x, z_i.y, 10, 10)
    draw_poly(radial_sort(zonoid_i, anchor: leftmost_point(zonoid_i), cw: true), fill_color:[85, 185, 102, 60], stroke_color:[16, 74, 34, 255])
  

  [zonoid, k_depth] = compute_zonoid_depth(input_points, new Point(mouseX, mouseY), return_zonoid:true)
  if k_depth > 0
    console.log "DEPTH: ", k_depth 
    for z_i in zonoid
      fill(16, 74, 34, 165)
      stroke(16, 74, 34, 255)
      ellipse(z_i.x, z_i.y, 20, 20)
    draw_poly(radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true), fill_color:[16, 74, 34, 100], stroke_color:[16, 74, 34, 255])


  fill(255, 121, 113, 180)
  stroke(130, 65, 85);
  line(0, mouseY, w, mouseY)
  line(mouseX, 0, mouseX, h)
  ellipse(mouseX, mouseY, 15, 15)
  fill("black");
  stroke("black");

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
