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



k_sets = false

sep_p1 = false
sep_p2 = false
m_sep = false
q_sep = false

setup = () ->
  createCanvas(w, h)
  fill('red')   
  frameRate(10);

  k_sets = compute_k_sets_disc_2(input_points, k:k)
  sep_p1 = k_sets[current_k_set].separator[0]
  sep_p2 = k_sets[current_k_set].separator[1]
  m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x)
  q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x)
  zonoid.push(k_sets[current_k_set].mean_point)

draw = () -> 
  background(255, 251, 234)

  # Draw input set
  fill(85, 185, 102, 60);
  stroke(17, 74, 27, 180);
  for p_i in input_points
    ellipse(p_i.x, p_i.y, 10, 10) 
  
  # Play the zonoid build-up animation 
  if build_zonoid

    # Draw the separator
    strokeWeight(5)
    stroke(255, 251, 234, Math.floor(255 * (1 - current_duration / animation_duration)));
    line(0, q_sep, w, m_sep * w + q_sep)
    stroke(17, 74, 27, Math.floor(180 * (1 - current_duration / animation_duration)));
    strokeWeight(2)
    line(0, q_sep, w, m_sep * w + q_sep)
    strokeWeight(1)
    for p_i in k_sets[current_k_set].elem_list
      fill(255, 123, 136, Math.floor(180 * (1 - current_duration / animation_duration)))
      stroke(130, 65, 104, Math.floor(255 * (1 - current_duration / animation_duration)))
      ellipse(p_i.x, p_i.y, 10, 10)
      ellipse(p_i.x, p_i.y, 14, 14)

    fill(16, 74, 34, 180)
    stroke(16, 74, 34, 255)

    for z_i in zonoid
      ellipse(z_i.x, z_i.y, 10, 10)
      ellipse(z_i.x, z_i.y, 20, 20)

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
      fill(16, 74, 34, 180)
      stroke(16, 74, 34, 255)
      ellipse(z_i.x, z_i.y, 20, 20)
      ellipse(z_i.x, z_i.y, 10, 10)
    if zonoid.length > 0
      draw_poly(radial_sort(zonoid, anchor: leftmost_point(zonoid), cw: true))
      draw_poly(zonoid, fill_color:[78, 185, 120, Math.floor(160 * current_duration / animation_duration)], stroke_color:[16, 74, 34, 255])
    if current_duration < animation_duration
      current_duration += 1
  

mouseWheel = (event) ->
  if !build_zonoid and current_duration == animation_duration
    if event.delta > 0
      k -= 1
    else if event.delta < 0
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
