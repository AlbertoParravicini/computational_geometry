input_points = [
  new Point(0.6, 1.9),
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

default_color = [121, 204, 147, 40]

num_input_points = 15

# Input points need to be rescaled to have dual lines that can be visualized.
# The scale factor says by how much each coordinate is divided.
scale_factor = 100

h = 480
w = 1200

dual_lines = []

k = 5
k_level = []

setup = () ->
  createCanvas(w, h)
  fill('red')   
  frameRate(10)


  for p in input_points
    dual_lines.push(create_line_from_m_q(p.x, p.y * scale_factor))

  k_level = compute_k_level(dual_lines, k)
  console.log k_level



draw = () -> 
  background(255, 251, 234)

  fill("black");
  stroke("black");

  for l in dual_lines
    ellipse(l.start.x, l.start.y, 8, 8)
    ellipse(l.end.x, l.end.y, 8, 8)
    line(l.start.x, l.start.y, l.end.x, l.end.y)
    
  fill("red")  
  stroke("red");
  strokeWeight(3)
  for p in k_level
    ellipse(p.x, p.y, 14, 14)
  for i in [1..k_level.length - 1]
    line(k_level[i - 1].x, k_level[i - 1].y, k_level[i].x, k_level[i].y)
  strokeWeight(1)


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
  console.log "K: ", k
    
    
