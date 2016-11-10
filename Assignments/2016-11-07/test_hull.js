// Generated by CoffeeScript 1.11.1
var convex_hull, draw, input_points, keyPressed, mousePressed, setup;

input_points = [new Point(300, 200), new Point(423, 100), new Point(100, 300), new Point(200, 400), new Point(100, 400), new Point(240, 320), new Point(280, 150)];

convex_hull = [];

setup = function() {
  createCanvas(640, 480);
  return fill('black');
};

draw = function() {
  var i, j, k, len, p_i, ref, ref1;
  background(200);
  line(0, 240, 640, 240);
  line(320, 0, 320, 480);
  fill("green");
  stroke("green");
  ellipse(0, 0, 6, 6);
  ellipse(input_points[0].x, input_points[0].y, 6, 6);
  stroke(51);
  fill(51);
  ref = input_points.slice(1);
  for (j = 0, len = ref.length; j < len; j++) {
    p_i = ref[j];
    ellipse(p_i.x, p_i.y, 4, 4);
  }
  if (convex_hull.length > 2) {
    fill("green");
    stroke("green");
    ellipse(convex_hull[0].x, convex_hull[0].y, 6, 6);
    fill("black");
    stroke("black");
    for (i = k = 1, ref1 = convex_hull.length - 1; 1 <= ref1 ? k <= ref1 : k >= ref1; i = 1 <= ref1 ? ++k : --k) {
      line(convex_hull[i - 1].x, convex_hull[i - 1].y, convex_hull[i].x, convex_hull[i].y);
    }
    return line(convex_hull[convex_hull.length - 1].x, convex_hull[convex_hull.length - 1].y, convex_hull[0].x, convex_hull[0].y);
  }
};

mousePressed = function() {
  return input_points.push(new Point(mouseX, mouseY));
};

keyPressed = function() {
  convex_hull = convex_hull_graham_scan(input_points);
  return console.log("size: ", convex_hull.length, "\nhull: ", convex_hull, "\n");
};
