input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
  new Point(200, 320), new Point(50, 40),new Point(50, 350), new Point(150, 350),
  new Point(220, 400), new Point(240, 320), new Point(280, 450)];

k = 1

zonoid = []

setup = () ->
  createCanvas(640, 480)
  fill('black')   

draw = () -> 
  background(200)
  line(0, 240, 640, 240)
  line(320, 0, 320, 480)

  fill("black");
  stroke("black");

  for p_i in input_points
    ellipse(p_i.x, p_i.y, 4, 4)
  
  

  fill("green");
  stroke("green");

  for z_i in zonoid
    ellipse(z_i.x, z_i.y, 10, 10)


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
  
  