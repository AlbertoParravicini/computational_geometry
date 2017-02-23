zonoids_k_sets_demo = (p_o) ->

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

  ###################
  # UTILITY FUNCTIONS
  ###################
  draw_poly = (p_o, points, {fill_color, stroke_color} = {}) ->
    fill_color ?= default_color
    stroke_color ?= default_color
    p_o.fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3])
    p_o.stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3])
    p_o.beginShape()
    for p_i in points 
      p_o.vertex(p_i.x, p_i.y)
    p_o.endShape(p_o.CLOSE)
    


  leftmost_point = (S) ->
    leftmost_p = S[0]
    for p in S[1..S.length - 1]
      if p.x < leftmost_p.x 
        leftmost_p = p 
    return leftmost_p

  ###################
  # DRAWING
  ###################


  p_o.setup = () ->
    canvas = p_o.createCanvas(w, h)
    p_o.fill('red')   
    p_o.frameRate(10)

    canvas.mouseWheel(canvas_mouseWheel)

  p_o.draw = () -> 
    p_o.background(253, 253, 253)

    p_o.fill(85, 185, 102, 60);
    p_o.stroke(17, 74, 27, 180);

    for p_i in input_points
      p_o.ellipse(p_i.x, p_i.y, 10, 10)



    for z_i in zonoid
      p_o.fill(16, 74, 34, 180)
      p_o.stroke(16, 74, 34, 255)
      p_o.ellipse(z_i.x, z_i.y, 20, 20)
      p_o.ellipse(z_i.x, z_i.y, 10, 10)
    if zonoid.length > 0
      draw_poly(p_o, zonoid, fill_color:[78, 185, 120, 160], stroke_color:[16, 74, 34, 255])


  p_o.keyPressed = () -> 
    if p_o.mouseX >= 0 and p_o.mouseX <= w and p_o.mouseY >= 0 and p_o.mouseY <= h
      if p_o.keyCode == p_o.DOWN_ARROW
        k -= 1      
      else if p_o.keyCode == p_o.UP_ARROW
        k += 1
      if k < 1
        k = 1
      if k > input_points.length
        k = input_points.length
      zonoid = compute_zonoid(input_points, k:k)
      zonoid = radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true)




  canvas_mouseWheel = (event) ->
    if event.deltaY > 0
      k -= 0.1
    else if event.deltaY < 0
      k += 0.1
    if k < 1
      k = 1
    if k > input_points.length
      k = input_points.length
    zonoid = compute_zonoid(input_points, k:k)
    zonoid = radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true)


# Instantiate a local variable for p5
zonoids_k_sets_p5 = new p5(zonoids_k_sets_demo, "demo-zonoid-k-sets-canvas")

