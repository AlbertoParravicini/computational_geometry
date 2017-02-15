input_points = [
  new Point(2, -2),
  new Point(-0.8, 4.2),
  new Point(1, 3),
  new Point(0.5, -1),
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
w = 640

dual_lines = []

setup = () ->
  createCanvas(w, h)
  fill('red')   
  frameRate(10)


  for p in input_points
    dual_lines.push(create_line_from_m_q(p.x, p.y * scale_factor))



draw = () -> 
  background(255, 251, 234)

  fill("black");
  stroke("black");

  for l in dual_lines
    ellipse(l.start.x, l.start.y, 10, 10)
    ellipse(l.end.x, l.end.y, 10, 10)
    line(l.start.x, l.start.y, l.end.x, l.end.y)
    
    
    
