zonoids_k_sets_anim_demo = (p_o) ->
  input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
      new Point(200, 320), new Point(50, 40),new Point(51, 350), new Point(150, 350),
      new Point(220, 400), new Point(240, 320), new Point(280, 450)];

  default_color = [121, 204, 147, 40]

  num_input_points = 15

  h = 480
  w = 640

  # for i in [0..num_input_points - 1]
  #   input_points.push(new Point(Math.floor(Math.random() * w), Math.floor(Math.random() * h)))

  k = 3

  k_set_num = 0

  zonoid = []
  # Check if we have to play the animation of the zonoid build-up
  build_zonoid = true

  # Current k-set that is being rendered in the animation
  current_k_set = 0

  # How many frames an animation should last
  animation_duration = 6

  # Keep track of the duration of the current animation
  current_duration = 0

  # True if we can start the animation. It is set to true after the canvas has appeared
  start_animation = false

  k_sets = false

  sep_p1 = false
  sep_p2 = false
  m_sep = false
  q_sep = false

  p_o.setup = () ->
    canvas = p_o.createCanvas(w, h)
    p_o.fill('red')   
    p_o.frameRate(10)

    canvas.mouseWheel(canvas_mouseWheel)

    k_sets = compute_k_sets_disc_2(input_points, k:k)
    sep_p1 = k_sets[current_k_set].separator[0]
    sep_p2 = k_sets[current_k_set].separator[1]
    m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x)
    q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x)
    zonoid.push(k_sets[current_k_set].mean_point)

  p_o.draw = () -> 
    p_o.background(253, 253, 253)

    # Draw input set
    p_o.fill(85, 185, 102, 60);
    p_o.stroke(17, 74, 27, 180);
    for p_i in input_points
      p_o.ellipse(p_i.x, p_i.y, 10, 10) 

    # Placing the cursor in the canvas will start the animation.
    if p_o.mouseX > 0 and p_o.mouseX < w and p_o.mouseY > 0 and p_o.mouseY < h
      start_animation = true
    
    # Play the zonoid build-up animation 
    if build_zonoid and start_animation

      # Draw the separator
      p_o.strokeWeight(5)
      p_o.stroke(255, 251, 234, Math.floor(255 * (1 - current_duration / animation_duration)));
      p_o.line(0, q_sep, w, m_sep * w + q_sep)
      p_o.stroke(17, 74, 27, Math.floor(180 * (1 - current_duration / animation_duration)));
      p_o.strokeWeight(2)
      p_o.line(0, q_sep, w, m_sep * w + q_sep)
      p_o.strokeWeight(1)
      for p_i in k_sets[current_k_set].elem_list
        p_o.fill(255, 123, 136, Math.floor(180 * (1 - current_duration / animation_duration)))
        p_o.stroke(130, 65, 104, Math.floor(255 * (1 - current_duration / animation_duration)))
        p_o.ellipse(p_i.x, p_i.y, 10, 10)
        p_o.ellipse(p_i.x, p_i.y, 14, 14)

      p_o.fill(16, 74, 34, 180)
      p_o.stroke(16, 74, 34, 255)

      for z_i in zonoid
        p_o.ellipse(z_i.x, z_i.y, 10, 10)
        p_o.ellipse(z_i.x, z_i.y, 20, 20)

      # Proceed to the next animation
      if current_k_set < k_sets.length - 1
        if current_duration >= animation_duration
          current_k_set += 1
          current_duration = 0
          sep_p1 = k_sets[current_k_set].separator[0]
          sep_p2 = k_sets[current_k_set].separator[1]
          m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x)
          q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x)

          zonoid.push(k_sets[current_k_set].mean_point)
        else 
          current_duration += 1
      # The animation is over, build the entire zonoid
      else 
        build_zonoid = false
        current_duration = 0
      
    # Draw the final zonoid
    else
      for z_i in zonoid
        p_o.fill(16, 74, 34, 180)
        p_o.stroke(16, 74, 34, 255)
        p_o.ellipse(z_i.x, z_i.y, 20, 20)
        p_o.ellipse(z_i.x, z_i.y, 10, 10)
      if zonoid.length > 0
        draw_poly(p_o, radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true))
        draw_poly(p_o, zonoid, fill_color:[78, 185, 120, Math.floor(160 * current_duration / animation_duration)], stroke_color:[16, 74, 34, 255])
      if current_duration < animation_duration
        current_duration += 1
    

  canvas_mouseWheel = (event) ->
    if !build_zonoid and current_duration == animation_duration
      if event.deltaY > 0
        k -= 1
      else if event.deltaY < 0
        k += 1
      if k < 1
        k = 1
      if k > input_points.length
        k = input_points.length
      k_sets = compute_k_sets_disc_2(input_points, k:k)
      current_k_set = 0
      sep_p1 = k_sets[current_k_set].separator[0]
      sep_p2 = k_sets[current_k_set].separator[1]
      m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x)
      q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x)
      zonoid = []
      zonoid.push(k_sets[current_k_set].mean_point)
      build_zonoid = true
      current_duration = 0



  draw_poly = (p_o, points, {fill_color, stroke_color} = {}) ->

    fill_color ?= default_color
    stroke_color ?= default_color
    p_o.fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3])
    p_o.stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3])
    p_o.beginShape()
    for p_i in points 
      p_o.vertex(p_i.x, p_i.y)
    p_o.endShape(p_o.CLOSE)
    
# Instantiate a local variable for p5
zonoids_k_sets_anim_p5 = new p5(zonoids_k_sets_anim_demo, "demo-zonoid-k-sets-anim-canvas")
