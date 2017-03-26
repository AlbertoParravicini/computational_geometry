zonoids_depth_demo = (p_o) ->
  input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
      new Point(200, 320), new Point(50, 40),new Point(51, 350), new Point(150, 350),
      new Point(220, 400), new Point(240, 320), new Point(280, 450)];


  num_input_points =  18

  query_point = false

  default_color = [121, 204, 147, 40]

  label = false


  h = 480
  w = 640


  zonoid = []

  zonoid_list = []



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
  # SETUP
  ###################

  for i in [1..input_points.length]
    zonoid_i = compute_zonoid(input_points, k:i, discrete:true)
    zonoid_list.push(radial_sort(zonoid_i, anchor: leftmost_point(zonoid_i), cw: true))


  ###################
  # DRAWING
  ###################

  p_o.setup = () ->
    canvas_zonoid_depth = p_o.createCanvas(w, h)
    p_o.fill('red')   
    p_o.frameRate(20)

    label = p_o.createElement('p', '<b>ZONOID DEPTH:</b> 0');
    
  

  p_o.draw = () -> 
  
    p_o.background(253, 253, 253)

    p_o.fill(118, 198, 222);
    p_o.stroke(118, 198, 222);

    for p_i in input_points
      p_o.ellipse(p_i.x, p_i.y, 6, 6)



    
    for zonoid_i in zonoid_list
      for z_i in zonoid_i
        p_o.fill(16, 74, 34, 60)
        p_o.stroke(16, 74, 34, 255)
        p_o.ellipse(z_i.x, z_i.y, 10, 10)
      draw_poly(p_o, zonoid_i, fill_color:[85, 185, 102, 60], stroke_color:[16, 74, 34, 255])
    
    if p_o.mouseX >= 0 and p_o.mouseX <= w and p_o.mouseY >= 0 and p_o.mouseY <= h
      [zonoid, k_depth] = compute_zonoid_depth(input_points, new Point(p_o.mouseX, p_o.mouseY), return_zonoid:true)
      if k_depth > 0
        console.log "DEPTH: ", k_depth 
        label.html("<b>ZONOID DEPTH:</b> " + k_depth)
        for z_i in zonoid
          p_o.fill(16, 74, 34, 165)
          p_o.stroke(16, 74, 34, 255)
          p_o.ellipse(z_i.x, z_i.y, 20, 20)
        draw_poly(p_o, radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true), fill_color:[16, 74, 34, 100], stroke_color:[16, 74, 34, 255])

      p_o.fill(255, 121, 113, 180)
      p_o.stroke(130, 65, 85);
      
      p_o.line(0, p_o.mouseY, w, p_o.mouseY)
      p_o.line(p_o.mouseX, 0, p_o.mouseX, h)
      p_o.ellipse(p_o.mouseX, p_o.mouseY, 15, 15)
    p_o.fill("black");
    p_o.stroke("black");


# Instantiate a local variable for p5
zonoids_depth_p5 = new p5(zonoids_depth_demo, "demo-zonoid-depth-canvas")



