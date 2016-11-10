// Generated by CoffeeScript 1.11.1
var draw, hull, input_points, keyPressed, mousePressed, new_point, setup;

input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), new Point(200, 320), new Point(50, 40), new Point(50, 350), new Point(150, 350), new Point(220, 400), new Point(240, 320), new Point(280, 450)];

new_point = new Point(320, 240);

hull = convex_hull_graham_scan(input_points);

setup = function() {
  createCanvas(640, 480);
  return fill('black');
};

draw = function() {
  var i, j, k, l, len, p_i, ref, ref1, results;
  background(200);
  line(0, 240, 640, 240);
  line(320, 0, 320, 480);
  fill("green");
  stroke("green");
  ellipse(new_point.x, new_point.y, 8, 8);
  fill("black");
  stroke("black");
  for (j = 0, len = hull.length; j < len; j++) {
    p_i = hull[j];
    ellipse(p_i.x, p_i.y, 4, 4);
  }
  if (hull.length > 2) {
    for (i = k = 0, ref = hull.length - 2; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
      line(hull[i].x, hull[i].y, hull[i + 1].x, hull[i + 1].y);
    }
    results = [];
    for (i = l = 2, ref1 = hull.length - 2; 2 <= ref1 ? l <= ref1 : l >= ref1; i = 2 <= ref1 ? ++l : --l) {
      stroke("red");
      line(hull[0].x, hull[0].y, hull[i].x, hull[i].y);
      results.push(stroke("black"));
    }
    return results;
  }
};

mousePressed = function() {
  return new_point = new Point(mouseX, mouseY);
};

keyPressed = function() {
  return console.log("result: ", inclusion_in_hull(hull, new_point), "\n");
};
