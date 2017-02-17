// Generated by CoffeeScript 1.12.3
var default_color, draw, dual_lines, h, input_points, k, k_level, mouseWheel, num_input_points, scale_factor, setup, w;

input_points = [new Point(2, -2), new Point(-0.8, 4.2), new Point(1, 3), new Point(0.1, 0.6), new Point(0.4, 1.2), new Point(-0.2, 2.2), new Point(1.4, 0.3), new Point(-0.3, 4.8)];

default_color = [121, 204, 147, 40];

num_input_points = 15;

scale_factor = 100;

h = 480;

w = 1200;

dual_lines = [];

k = 5;

k_level = [];

setup = function() {
  var j, len, p;
  createCanvas(w, h);
  fill('red');
  frameRate(10);
  for (j = 0, len = input_points.length; j < len; j++) {
    p = input_points[j];
    dual_lines.push(create_line_from_m_q(p.x, p.y * scale_factor));
  }
  k_level = compute_k_level(dual_lines, k);
  return console.log(k_level);
};

draw = function() {
  var i, j, l, len, len1, m, n, p, ref, ref1;
  background(255, 251, 234);
  fill("black");
  stroke("black");
  for (j = 0, len = dual_lines.length; j < len; j++) {
    l = dual_lines[j];
    strokeWeight(2);
    line(l.start.x, l.start.y, l.end.x, l.end.y);
  }
  fill("red");
  stroke("red");
  strokeWeight(3);
  ref = k_level.slice(1, +(k_level.length - 1) + 1 || 9e9);
  for (m = 0, len1 = ref.length; m < len1; m++) {
    p = ref[m];
    ellipse(p.x, p.y, 14, 14);
  }
  for (i = n = 1, ref1 = k_level.length - 1; 1 <= ref1 ? n <= ref1 : n >= ref1; i = 1 <= ref1 ? ++n : --n) {
    line(k_level[i - 1].x, k_level[i - 1].y, k_level[i].x, k_level[i].y);
  }
  return strokeWeight(1);
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
  if (k > dual_lines.length) {
    k = dual_lines.length;
  }
  k_level = compute_k_level(dual_lines, k);
  return console.log("K: ", k);
};
