// Generated by CoffeeScript 1.12.3
(function() {
  var zonoids_k_sets_demo, zonoids_k_sets_p5;

  zonoids_k_sets_demo = function(p_o) {
    var canvas_mouseWheel, default_color, draw_poly, h, input_points, k, label, leftmost_point, num_input_points, select_event, slider, w, zonoid;
    input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), new Point(200, 320), new Point(50, 40), new Point(51, 350), new Point(150, 350), new Point(220, 400), new Point(240, 320), new Point(280, 450)];
    default_color = [121, 204, 147, 40];
    num_input_points = 15;
    h = 480;
    w = 640;
    k = 1;
    slider = false;
    label = false;
    zonoid = [];
    draw_poly = function(p_o, points, arg) {
      var fill_color, i, len, p_i, ref, stroke_color;
      ref = arg != null ? arg : {}, fill_color = ref.fill_color, stroke_color = ref.stroke_color;
      if (fill_color == null) {
        fill_color = default_color;
      }
      if (stroke_color == null) {
        stroke_color = default_color;
      }
      p_o.fill(fill_color[0], fill_color[1], fill_color[2], fill_color[3]);
      p_o.stroke(stroke_color[0], stroke_color[1], stroke_color[2], stroke_color[3]);
      p_o.beginShape();
      for (i = 0, len = points.length; i < len; i++) {
        p_i = points[i];
        p_o.vertex(p_i.x, p_i.y);
      }
      return p_o.endShape(p_o.CLOSE);
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
    p_o.setup = function() {
      var canvas;
      canvas = p_o.createCanvas(w, h);
      p_o.fill('red');
      p_o.frameRate(10);
      slider = p_o.createSlider(1, input_points.length, k, 0.1);
      slider.changed(select_event);
      label = p_o.createElement('p', 'Value of K');
      label.html("<b>K:</b> " + k);
      canvas.mouseWheel(canvas_mouseWheel);
      zonoid = compute_zonoid(input_points, {
        k: k
      });
      return zonoid = radial_sort(zonoid, {
        anchor: leftmost_point(zonoid),
        cw: true
      });
    };
    p_o.draw = function() {
      var i, j, len, len1, p_i, z_i;
      p_o.background(253, 253, 253);
      p_o.fill(85, 185, 102, 60);
      p_o.stroke(17, 74, 27, 180);
      for (i = 0, len = input_points.length; i < len; i++) {
        p_i = input_points[i];
        p_o.ellipse(p_i.x, p_i.y, 10, 10);
      }
      for (j = 0, len1 = zonoid.length; j < len1; j++) {
        z_i = zonoid[j];
        p_o.fill(16, 74, 34, 180);
        p_o.stroke(16, 74, 34, 255);
        p_o.ellipse(z_i.x, z_i.y, 20, 20);
        p_o.ellipse(z_i.x, z_i.y, 10, 10);
      }
      if (zonoid.length > 0) {
        return draw_poly(p_o, zonoid, {
          fill_color: [78, 185, 120, 160],
          stroke_color: [16, 74, 34, 255]
        });
      }
    };
    p_o.keyPressed = function() {
      if (p_o.mouseX >= 0 && p_o.mouseX <= w && p_o.mouseY >= 0 && p_o.mouseY <= h) {
        if (p_o.keyCode === p_o.DOWN_ARROW) {
          k -= 1;
        } else if (p_o.keyCode === p_o.UP_ARROW) {
          k += 1;
        }
        if (k < 1) {
          k = 1;
        }
        if (k > input_points.length) {
          k = input_points.length;
        }
        slider.value(k);
        label.html("<b>K:</b> " + k);
        zonoid = compute_zonoid(input_points, {
          k: k
        });
        return zonoid = radial_sort(zonoid, {
          anchor: leftmost_point(zonoid),
          cw: true
        });
      }
    };
    select_event = function() {
      k = slider.value();
      label.html("<b>K:</b> " + k);
      zonoid = compute_zonoid(input_points, {
        k: k
      });
      return zonoid = radial_sort(zonoid, {
        anchor: leftmost_point(zonoid),
        cw: true
      });
    };
    return canvas_mouseWheel = function(event) {
      if (event.deltaY > 0) {
        k -= 0.1;
      } else if (event.deltaY < 0) {
        k += 0.1;
      }
      if (k < 1) {
        k = 1;
      }
      if (k > input_points.length) {
        k = input_points.length;
      }
      slider.value(k);
      label.html("<b>K:</b> " + k);
      zonoid = compute_zonoid(input_points, {
        k: k
      });
      return zonoid = radial_sort(zonoid, {
        anchor: leftmost_point(zonoid),
        cw: true
      });
    };
  };

  zonoids_k_sets_p5 = new p5(zonoids_k_sets_demo, "demo-zonoid-k-sets-canvas");

}).call(this);
