input_points = [
  new Point(100, 10),
  new Point(300, 200), 
  new Point(423, 200), 
  new Point(101, 300), 
  new Point(500, 120), 
  new Point(200, 320),
  new Point(50, 40),
  new Point(51, 350), 
  new Point(150, 350),
  new Point(220, 400),
  new Point(240, 320), 
  new Point(280, 450)]
  
default_color = [121, 204, 147, 40]

num_input_points = 15

h = 480
w = 640

# for i in [0..num_input_points - 1]
#   input_points.push(new Point(Math.floor(Math.random() * w), Math.floor(Math.random() * h)))

k = 1

k_set_num = 0

zonoid = []
k_sets = false

sep_p1 = false
sep_p2 = false
m_sep = false
q_sep = false

canvas = false


setup = () ->
  canvas = createCanvas(w, h)
  canvas.parent('test-k-sets-canvas')
  fill('red')   
  frameRate(10)

  canvas.mouseWheel(canvas_mouseWheel)

draw = () -> 
  background(255, 251, 234)

  fill(85, 185, 102, 60);
  stroke(17, 74, 27, 180);


  for p_i in input_points
    ellipse(p_i.x, p_i.y, 10, 10)

  if k_sets
    # Draw the separator
    strokeWeight(5)
    stroke(255, 251, 234);
    line(0, q_sep, w, m_sep * w + q_sep)
    stroke(17, 74, 27, 180);
    strokeWeight(2)
    line(0, q_sep, w, m_sep * w + q_sep)
    strokeWeight(1)
    for p_i in k_sets[k_set_num].elem_list
      fill(255, 123, 136, 180)
      stroke(130, 65, 104, 255)
      ellipse(p_i.x, p_i.y, 10, 10)
      ellipse(p_i.x, p_i.y, 14, 14)

    fill(16, 74, 34, 180)
    stroke(16, 74, 34, 255)
    ellipse(k_sets[k_set_num].mean_point.x, k_sets[k_set_num].mean_point.y, 10, 10)
    ellipse(k_sets[k_set_num].mean_point.x, k_sets[k_set_num].mean_point.y, 20, 20)


      


keyPressed = () -> 
    if keyCode == UP_ARROW
      k_set_num += 1
    else if keyCode == DOWN_ARROW
      k_set_num -= 1

    if k_set_num < 0
      k_set_num = k_sets.length - 1
    if k_set_num >= k_sets.length
      k_set_num = 0
    sep_p1 = k_sets[k_set_num].separator[0]
    sep_p2 = k_sets[k_set_num].separator[1]
    m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x + 0.00001) 
    q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x + 0.00001)
    

    
canvas_mouseWheel = (event) ->
  if event.deltaY > 0
    k -= 1
  else if event.deltaY < 0
    k += 1
  if k < 1
    k = 1
  if k > input_points.length
    k = input_points.length
  k_sets = compute_k_sets_disc_2(input_points, k:k)
  k_set_num = 0
  sep_p1 = k_sets[k_set_num].separator[0]
  sep_p2 = k_sets[k_set_num].separator[1]
  m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x + 0.00001)
  q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x + 0.00001)



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
