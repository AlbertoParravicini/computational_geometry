// function setup() {
//   var canvas = createCanvas(1200, 800);

//   // Move the canvas so it's inside our <div id="sketch-holder">.
//   canvas.parent('sketch-holder');

//   background(255, 0, 200);
// }

var draw, draw_shape, drawing_polygon_done, h, input_points, keyPressed, mousePressed, query_point, result, setup, w;

  input_points = [];

  drawing_polygon_done = false;

  query_point = false;

  result = false;

  w = 1200;

  h = 800;

  function setup() {
    var canvas;
    canvas = createCanvas(w, h);
    canvas.parent('sketch-holder');
    background(10, 10, 10);
  };

  draw = function() {
    var i, j, k, len, p_i, ref;
    background(230);
    line(0, h / 2, w, h / 2);
    line(w / 2, 0, w / 2, h);
    fill("black");
    stroke("black");
    for (j = 0, len = input_points.length; j < len; j++) {
      p_i = input_points[j];
      ellipse(p_i.x, p_i.y, 4, 4);
    }
    if (input_points.length >= 2) {
      if (!drawing_polygon_done) {
        for (i = k = 0, ref = input_points.length - 2; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
          line(input_points[i].x, input_points[i].y, input_points[i + 1].x, input_points[i + 1].y);
        }
      }
    }
    if (drawing_polygon_done) {
      result = check_inclusion_in_polygon(input_points, new Point(mouseX, mouseY)) ? "INSIDE" : "OUTSIDE";
      if (result === "INSIDE") {
        fill("green");
        stroke("green");
      } else {
        fill("red");
        stroke("red");
      }
      ellipse(mouseX, mouseY, 15, 15);
      line(0, mouseY, w, mouseY);
      fill("black");
      stroke("black");
      return draw_shape(input_points);
    }
  };

  mousePressed = function() {
    var close_enough, direction, new_point;
    if (!drawing_polygon_done) {
      new_point = new Point(mouseX, mouseY);
      if (input_points.length > 2) {
        close_enough = Math.pow(new_point.x - input_points[0].x, 2) + Math.pow(new_point.y - input_points[0].y, 2) <= h / 2;
        if (close_enough) {
          if (check_self_intersection_new_point(input_points, input_points[0])) {
            return console.log(new_point, "creates a self-intersection!");
          } else {
            drawing_polygon_done = true;
            direction = simple_polygon_orientation_clockwise(input_points) ? "counter-clockwise" : "clockwise";
            return console.log("direction: ", direction, "\n");
          }
        } else {
          if (check_self_intersection_new_point(input_points, new_point)) {
            return console.log(new_point, "creates a self-intersection!");
          } else {
            return input_points.push(new_point);
          }
        }
      } else {
        return input_points.push(new_point);
      }
    }
  };

  keyPressed = function() {
    var direction;
    if (input_points.length > 2 && !drawing_polygon_done) {
      if (check_self_intersection_new_point(input_points, input_points[0])) {
        return console.log("Closing the polygon creates a self-intersection!");
      } else {
        drawing_polygon_done = true;
        direction = simple_polygon_orientation_clockwise(input_points) ? "counter-clockwise" : "clockwise";
        return console.log("direction: ", direction, "\n");
      }
    }
  };

  draw_shape = function(points) {
    var j, len, p_i;
    if (result === "INSIDE") {
      fill(153, 255, 153, 40);
    } else {
      fill(255, 179, 179, 40);
    }
    beginShape();
    for (j = 0, len = points.length; j < len; j++) {
      p_i = points[j];
      vertex(p_i.x, p_i.y);
    }
    return endShape(CLOSE);
  };