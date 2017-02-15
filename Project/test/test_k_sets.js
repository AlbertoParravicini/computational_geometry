// Generated by CoffeeScript 1.12.3
var default_color, draw, draw_poly, h, input_points, k, k_set_num, k_sets, keyPressed, leftmost_point, m_sep, mouseWheel, num_input_points, q_sep, sep_p1, sep_p2, setup, w, zonoid;

input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), new Point(200, 320), new Point(50, 40), new Point(51, 350), new Point(150, 350), new Point(220, 400), new Point(240, 320), new Point(280, 450)];

default_color = [121, 204, 147, 40];

num_input_points = 15;

h = 480;

w = 640;

k = 1;

k_set_num = 0;

zonoid = [];

k_sets = false;

sep_p1 = false;

sep_p2 = false;

m_sep = false;

q_sep = false;

setup = function() {
  createCanvas(w, h);
  fill('red');
  return frameRate(10);
};

draw = function() {
  var i, j, len, len1, p_i, ref;
  background(255, 251, 234);
  fill(85, 185, 102, 60);
  stroke(17, 74, 27, 180);
  for (i = 0, len = input_points.length; i < len; i++) {
    p_i = input_points[i];
    ellipse(p_i.x, p_i.y, 10, 10);
  }
  if (k_sets) {
    strokeWeight(5);
    stroke(255, 251, 234);
    line(0, q_sep, w, m_sep * w + q_sep);
    stroke(17, 74, 27, 180);
    strokeWeight(2);
    line(0, q_sep, w, m_sep * w + q_sep);
    strokeWeight(1);
    ref = k_sets[k_set_num].elem_list;
    for (j = 0, len1 = ref.length; j < len1; j++) {
      p_i = ref[j];
      fill(255, 123, 136, 180);
      stroke(130, 65, 104, 255);
      ellipse(p_i.x, p_i.y, 10, 10);
      ellipse(p_i.x, p_i.y, 14, 14);
    }
    fill(16, 74, 34, 180);
    stroke(16, 74, 34, 255);
    ellipse(k_sets[k_set_num].mean_point.x, k_sets[k_set_num].mean_point.y, 10, 10);
    return ellipse(k_sets[k_set_num].mean_point.x, k_sets[k_set_num].mean_point.y, 20, 20);
  }
};

keyPressed = function() {
  if (keyCode === UP_ARROW) {
    k_set_num += 1;
  } else if (keyCode === DOWN_ARROW) {
    k_set_num -= 1;
  }
  if (k_set_num < 0) {
    k_set_num = 0;
  }
  if (k_set_num >= k_sets.length) {
    k_set_num = k_sets.length - 1;
  }
  sep_p1 = k_sets[k_set_num].separator[0];
  sep_p2 = k_sets[k_set_num].separator[1];
  m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x);
  return q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x);
};

mouseWheel = function(event) {
  if (event.delta > 0) {
    k -= 1;
  } else if (event.delta < 0) {
    k += 1;
  }
  if (k < 1) {
    k = 1;
  }
  if (k > input_points.length) {
    k = input_points.length;
  }
  k_sets = compute_k_sets_disc_2(input_points, {
    k: k
  });
  k_set_num = 0;
  sep_p1 = k_sets[k_set_num].separator[0];
  sep_p2 = k_sets[k_set_num].separator[1];
  m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x);
  return q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x);
};

draw_poly = function(points, arg) {
  var fill_color, i, len, p_i, ref, stroke_color;
  ref = arg != null ? arg : {}, fill_color = ref.fill_color, stroke_color = ref.stroke_color;
  if (fill_color == null) {
    fill_color = default_color;
  }
  if (stroke_color == null) {
    stroke_color = default_color;
  }
  fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3]);
  stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3]);
  beginShape();
  for (i = 0, len = points.length; i < len; i++) {
    p_i = points[i];
    vertex(p_i.x, p_i.y);
  }
  return endShape(CLOSE);
};

leftmost_point = function(S) {
  var i, leftmost_p, len, p, ref;
  leftmost_p = S[0];
  ref = S.slice(1, +(S.length - 1) + 1 || 9e9);
  for (i = 0, len = ref.length; i < len; i++) {
    p = ref[i];
    if (p.x < leftmost_p.x) {
      leftmost_p = p;
    }
  }
  return leftmost_p;
};
