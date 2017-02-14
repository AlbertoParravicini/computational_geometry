// Generated by CoffeeScript 1.12.3
var draw, draw_poly, h, input_points, k, keyPressed, leftmost_point, mouseWheel, num_input_points, setup, w, zonoid;

input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), new Point(200, 320), new Point(50, 40), new Point(51, 350), new Point(150, 350), new Point(220, 400), new Point(240, 320), new Point(280, 450)];

num_input_points = 15;

h = 480;

w = 640;

k = 1;

zonoid = [];

setup = function() {
  createCanvas(w, h);
  return fill('red');
};

draw = function() {
  var i, j, len, len1, p_i, z_i;
  background(255, 251, 234);
  fill(118, 198, 222);
  stroke(118, 198, 222);
  for (i = 0, len = input_points.length; i < len; i++) {
    p_i = input_points[i];
    ellipse(p_i.x, p_i.y, 6, 6);
  }
  fill(16, 74, 34, 180);
  stroke(16, 74, 34);
  for (j = 0, len1 = zonoid.length; j < len1; j++) {
    z_i = zonoid[j];
    ellipse(z_i.x, z_i.y, 10, 10);
  }
  if (zonoid.length > 0) {
    draw_poly(radial_sort(zonoid, {
      anchor: leftmost_point(zonoid),
      cw: true
    }));
    return draw_poly(zonoid);
  }
};

keyPressed = function() {
  if (keyCode === LEFT_ARROW) {
    k -= 1;
  } else if (keyCode === RIGHT_ARROW) {
    k += 1;
  }
  if (k < 1) {
    k = 1;
  }
  if (k > input_points.length) {
    k = input_points.length;
  }
  return zonoid = compute_zonoid(input_points, {
    k: k
  });
};

mouseWheel = function(event) {
  if (event.delta > 0) {
    k -= 0.1;
  } else if (event.delta < 0) {
    k += 0.1;
  }
  if (k < 1) {
    k = 1;
  }
  if (k > input_points.length) {
    k = input_points.length;
  }
  return zonoid = compute_zonoid(input_points, {
    k: k
  });
};

draw_poly = function(points) {
  var i, len, p_i;
  fill(121, 204, 147, 40);
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
