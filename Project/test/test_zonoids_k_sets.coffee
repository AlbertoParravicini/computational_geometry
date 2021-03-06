input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
    new Point(200, 320), new Point(50, 40),new Point(51, 350), new Point(150, 350),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];

default_color = [121, 204, 147, 40]

num_input_points = 15

h = 480
w = 640

# for i in [0..num_input_points - 1]
#   input_points.push(new Point(Math.floor(Math.random() * w), Math.floor(Math.random() * h)))

k = 1

zonoid = []

setup = () ->
  createCanvas(w, h)
  fill('red')   

draw = () -> 
  background(255, 251, 234)

  fill(85, 185, 102, 60);
  stroke(17, 74, 27, 180);

  for p_i in input_points
    ellipse(p_i.x, p_i.y, 10, 10)


  for z_i in zonoid
    fill(16, 74, 34, 180)
    stroke(16, 74, 34, 255)
    ellipse(z_i.x, z_i.y, 20, 20)
    ellipse(z_i.x, z_i.y, 10, 10)
  if zonoid.length > 0
    draw_poly(radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true), fill_color:[78, 185, 120, 160], stroke_color:[16, 74, 34, 255])


keyPressed = () -> 
    if keyCode == LEFT_ARROW
      k -= 1
        
    else if keyCode == RIGHT_ARROW
      k += 1
    if k < 1
      k = 1
    if k > input_points.length
      k = input_points.length
    zonoid = compute_zonoid(input_points, k:k)



mouseWheel = (event) ->
  if event.delta > 0
    k -= 0.1
  else if event.delta < 0
    k += 0.1
  if k < 1
    k = 1
  if k > input_points.length
    k = input_points.length
  zonoid = compute_zonoid(input_points, k:k)



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
