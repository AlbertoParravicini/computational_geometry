k_level_1_demo = (p_o) ->
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

  w = 640
  h = 480

  # Size of half axis in the original canvas
  canvas_bound_original = 5

  dual_lines = []
  dual_lines_temp = []

  k = 1

  k_level_u = []
  reflex_vertices_u = []
  zonoid_vertices_u = []

  k_level_u_temp = []
  reflex_vertices_u_temp = []

  zonoid_lines = []


  zonoid = []

  slider = false
  label = false


  p_o.setup = () ->
    canvas = p_o.createCanvas(w, h)
    p_o.fill('red')   
    p_o.frameRate(6)

    canvas.mouseWheel(canvas_mouseWheel)

    for p in input_points
      dual_lines.push(create_line_from_m_q(p.x, p.y))
    # For displaying the duals
    dual_lines_temp = dual_lines.map((l) -> return [
        new Point(l.start.x * scale_factor, l.start.y * scale_factor),
        new Point(l.end.x * scale_factor, l.end.y * scale_factor)
        ])

    slider = p_o.createSlider(1, input_points.length, k, 1);
    slider.changed(select_event);

    label = p_o.createElement('p', 'Value of K');
    label.html("<b>K:</b> " + k)

    k_level_u = compute_k_level(dual_lines, k, reverse:true)
    reflex_vertices_u = compute_reflex_vertices(k_level_u, up:false)
    zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, up:false)
    # For displaying the duals
    k_level_u_temp = k_level_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    reflex_vertices_u_temp = reflex_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))


      
  p_o.draw = () -> 
    p_o.background(253, 253, 253)

    p_o.fill("black");
    p_o.stroke("black");


    for l in dual_lines_temp
      p_o.stroke(default_color)
      p_o.strokeWeight(2)
      p_o.line(l[0].x, l[0].y, l[1].x, l[1].y)


    # DRAW K-LEVEL UPPER   
    p_o.fill(143, 27, 10, 200)  
    p_o.stroke(231, 120, 58, 200)
    #k_level_u_temp = k_level_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    for i in [1..k_level_u.length - 1]
      p_o.strokeWeight(6)
      
      p_o.line(k_level_u_temp[i - 1].x, k_level_u_temp[i - 1].y, k_level_u_temp[i].x, k_level_u_temp[i].y)
    p_o.strokeWeight(1)

    # DRAW REFLEX VERTICES UPPER
    #for p in reflex_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    for p in reflex_vertices_u_temp
      p_o.fill(143, 27, 10, 200)  
      p_o.stroke(231, 120, 58, 200)
      p_o.ellipse(p.x, p.y, 20, 20)

  canvas_mouseWheel = (event) ->
    if event.deltaY > 0
      k -= 1
    else if event.deltaY < 0
      k += 1
    if k < 1
      k = 1
    if k > dual_lines.length 
      k = dual_lines.length 
    k_level_u = compute_k_level(dual_lines, k, reverse:true)
    reflex_vertices_u = compute_reflex_vertices(k_level_u, up:false)

    slider.value(k)
    label.html("<b>K:</b> " + k)

    # For displaying the duals
    k_level_u_temp = k_level_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    reflex_vertices_u_temp = reflex_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))


  select_event = () ->
    k = slider.value()
    label.html("<b>K:</b> " + k)
    k_level_u = compute_k_level(dual_lines, k, reverse:true)
    reflex_vertices_u = compute_reflex_vertices(k_level_u, up:false)
    # For displaying the duals
    k_level_u_temp = k_level_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))
    reflex_vertices_u_temp = reflex_vertices_u.map((p) -> return new Point(p.x * scale_factor, p.y * scale_factor))

  draw_poly = (p_o, points, {fill_color, stroke_color} = {}) ->

    fill_color ?= default_color
    stroke_color ?= default_color
    p_o.fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3])
    p_o.stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3])
    p_o.beginShape()
    for p_i in points 
      p_o.vertex(p_i.x, p_i.y)
    p_o.endShape(p_o.CLOSE)
    p_o.fill("black")
    p_o.stroke("black")
    

# Instantiate a local variable for p5
k_levels_1_p5 = new p5(k_level_1_demo, "demo-k-levels-1-canvas")

