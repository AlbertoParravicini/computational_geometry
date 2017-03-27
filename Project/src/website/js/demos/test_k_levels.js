// Generated by CoffeeScript 1.12.3
(function() {
  var zonoid_k_levels_p5, zonoids_k_level_demo;

  zonoids_k_level_demo = function(p_o) {
    var canvas_bound_original, canvas_mouseWheel, default_color, draw_poly, dual_lines, dual_lines_temp, h, input_points, k, k_level_d, k_level_d_temp, k_level_u, k_level_u_temp, label, num_input_points, reflex_vertices_d, reflex_vertices_d_temp, reflex_vertices_u, reflex_vertices_u_temp, scale_factor, select_event, slider, w, zonoid, zonoid_lines, zonoid_temp, zonoid_vertices_d, zonoid_vertices_d_temp, zonoid_vertices_u, zonoid_vertices_u_temp;
    input_points = [new Point(0.31, 3), new Point(0.1, 0.6), new Point(0.4, 1.2), new Point(-0.4, 4.2), new Point(-0.3, 5), new Point(0.9, 0.3), new Point(0.8, -0.6), new Point(-0.8, 6), new Point(0.05, 2)];
    default_color = [121, 204, 147, 200];
    num_input_points = 15;
    scale_factor = 80;
    w = 1200;
    h = 600;
    canvas_bound_original = 5;
    dual_lines = [];
    dual_lines_temp = [];
    k = 3;
    k_level_u = [];
    reflex_vertices_u = [];
    zonoid_vertices_u = [];
    k_level_d = [];
    reflex_vertices_d = [];
    zonoid_vertices_d = [];
    k_level_u_temp = [];
    reflex_vertices_u_temp = [];
    k_level_d_temp = [];
    reflex_vertices_d_temp = [];
    zonoid_vertices_u_temp = [];
    zonoid_vertices_d_temp = [];
    zonoid_lines = [];
    zonoid = [];
    zonoid_temp = [];
    slider = false;
    label = false;
    p_o.setup = function() {
      var canvas, j, len, len1, m, p, p_i, zonoid_dual_vertices;
      canvas = p_o.createCanvas(w, h);
      p_o.fill('red');
      p_o.frameRate(3);
      canvas.mouseWheel(canvas_mouseWheel);
      for (j = 0, len = input_points.length; j < len; j++) {
        p = input_points[j];
        dual_lines.push(create_line_from_m_q(p.x, p.y));
      }
      dual_lines_temp = dual_lines.map(function(l) {
        return [new Point(l.start.x * scale_factor, l.start.y * scale_factor), new Point(l.end.x * scale_factor, l.end.y * scale_factor)];
      });
      k_level_u = compute_k_level(dual_lines, k, {
        reverse: true
      });
      reflex_vertices_u = compute_reflex_vertices(k_level_u, {
        up: false
      });
      zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, {
        up: false
      });
      k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1, {
        reverse: true
      });
      reflex_vertices_d = compute_reflex_vertices(k_level_d, {
        up: true
      });
      zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, {
        up: true
      });
      slider = p_o.createSlider(2, dual_lines.length, k, 1);
      slider.changed(select_event);
      slider.position(0, 590);
      label = p_o.createElement('p', 'Value of K');
      label.html("<b>K:</b> " + k);
      label.position(10, 570);
      k_level_u_temp = k_level_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_u_temp = reflex_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      k_level_d_temp = k_level_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_d_temp = reflex_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_u_temp = zonoid_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_d_temp = zonoid_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d);
      for (m = 0, len1 = zonoid_dual_vertices.length; m < len1; m++) {
        p_i = zonoid_dual_vertices[m];
        zonoid_lines.push(new Line(new Point(-10000, -p_i.x * -10000 + p_i.y), new Point(10000, -p_i.x * 10000 + p_i.y), -p_i.x, p_i.y));
      }
      zonoid = compute_zonoid(input_points, {
        k: k - 1
      });
      zonoid_temp = zonoid.map(function(p) {
        return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100);
      });
      return zonoid_temp = radial_sort(zonoid_temp, {
        anchor: leftmost_point(zonoid_temp),
        cw: true
      });
    };
    p_o.draw = function() {
      var i, i1, j, j1, l, l_i, len, len1, len2, len3, len4, len5, len6, len7, m, n, o, p, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, s, t, u, v, w_2, x, y, z, z_i, zonoid_slice_d, zonoid_slice_u;
      p_o.background(253, 253, 253);
      p_o.fill("black");
      p_o.stroke("black");
      for (j = 0, len = dual_lines_temp.length; j < len; j++) {
        l = dual_lines_temp[j];
        p_o.stroke(default_color);
        p_o.strokeWeight(2);
        p_o.line(l[0].x, l[0].y, l[1].x, l[1].y);
      }
      p_o.fill(143, 27, 10, 200);
      p_o.stroke(231, 120, 58, 200);
      for (i = m = 1, ref = k_level_u.length - 1; 1 <= ref ? m <= ref : m >= ref; i = 1 <= ref ? ++m : --m) {
        p_o.strokeWeight(6);
        p_o.line(k_level_u_temp[i - 1].x, k_level_u_temp[i - 1].y, k_level_u_temp[i].x, k_level_u_temp[i].y);
      }
      p_o.strokeWeight(1);
      for (n = 0, len1 = reflex_vertices_u_temp.length; n < len1; n++) {
        p = reflex_vertices_u_temp[n];
        p_o.fill(143, 27, 10, 200);
        p_o.stroke(231, 120, 58, 200);
        p_o.ellipse(p.x, p.y, 20, 20);
        y = p.y + 15;
        p_o.fill(default_color);
        p_o.stroke(default_color);
        p_o.strokeWeight(2);
      }
      p_o.fill(143, 27, 10, 200);
      p_o.stroke(231, 120, 58, 200);
      p_o.strokeWeight(6);
      if (zonoid_vertices_u_temp.length > 1) {
        for (i = o = 1, ref1 = zonoid_vertices_u_temp.length - 1; 1 <= ref1 ? o <= ref1 : o >= ref1; i = 1 <= ref1 ? ++o : --o) {
          p_o.line(zonoid_vertices_u_temp[i - 1].x, zonoid_vertices_u_temp[i - 1].y, zonoid_vertices_u_temp[i].x, zonoid_vertices_u_temp[i].y);
        }
      }
      p_o.strokeWeight(2);
      for (q = 0, len2 = zonoid_vertices_u_temp.length; q < len2; q++) {
        p = zonoid_vertices_u_temp[q];
        p_o.ellipse(p.x, p.y, 20, 20);
      }
      if (zonoid_vertices_u_temp.length > 1) {
        for (i = r = 1, ref2 = zonoid_vertices_u_temp.length - 1; 1 <= ref2 ? r <= ref2 : r >= ref2; i = 1 <= ref2 ? ++r : --r) {
          zonoid_slice_u = [zonoid_vertices_u_temp[i - 1], zonoid_vertices_u_temp[i], new Point(zonoid_vertices_u_temp[i].x, 10000), new Point(zonoid_vertices_u_temp[i - 1].x, 10000)];
          draw_poly(p_o, zonoid_slice_u, {
            fill_color: [231, 120, 58, 40],
            stroke_color: [16, 74, 34, 0]
          });
        }
      }
      p_o.fill(98, 122, 161, 200);
      p_o.stroke(21, 32, 50, 200);
      for (i = s = 1, ref3 = k_level_d_temp.length - 1; 1 <= ref3 ? s <= ref3 : s >= ref3; i = 1 <= ref3 ? ++s : --s) {
        p_o.strokeWeight(6);
        p_o.line(k_level_d_temp[i - 1].x, k_level_d_temp[i - 1].y, k_level_d_temp[i].x, k_level_d_temp[i].y);
      }
      p_o.strokeWeight(2);
      for (t = 0, len3 = reflex_vertices_d_temp.length; t < len3; t++) {
        p = reflex_vertices_d_temp[t];
        p_o.fill(98, 122, 161, 200);
        p_o.stroke(21, 32, 50, 200);
        p_o.ellipse(p.x, p.y, 20, 20);
        y = p.y - 15;
        p_o.fill(default_color);
        p_o.stroke(default_color);
        p_o.strokeWeight(2);
      }
      p_o.fill(98, 122, 161, 200);
      p_o.stroke(21, 32, 50, 200);
      p_o.strokeWeight(6);
      if (zonoid_vertices_d_temp.length > 1) {
        for (i = u = 1, ref4 = zonoid_vertices_d_temp.length - 1; 1 <= ref4 ? u <= ref4 : u >= ref4; i = 1 <= ref4 ? ++u : --u) {
          p_o.line(zonoid_vertices_d_temp[i - 1].x, zonoid_vertices_d_temp[i - 1].y, zonoid_vertices_d_temp[i].x, zonoid_vertices_d_temp[i].y);
        }
      }
      p_o.strokeWeight(2);
      for (v = 0, len4 = zonoid_vertices_d_temp.length; v < len4; v++) {
        p = zonoid_vertices_d_temp[v];
        p_o.ellipse(p.x, p.y, 20, 20);
      }
      if (zonoid_vertices_d_temp.length > 1) {
        for (i = x = 1, ref5 = zonoid_vertices_d_temp.length - 1; 1 <= ref5 ? x <= ref5 : x >= ref5; i = 1 <= ref5 ? ++x : --x) {
          zonoid_slice_d = [zonoid_vertices_d_temp[i - 1], zonoid_vertices_d_temp[i], new Point(zonoid_vertices_d_temp[i].x, -10000), new Point(zonoid_vertices_d_temp[i - 1].x, -10000)];
          draw_poly(p_o, zonoid_slice_d, {
            fill_color: [21, 32, 50, 40],
            stroke_color: [16, 74, 34, 0]
          });
        }
      }
      w_2 = w / 2;
      draw_poly(p_o, [new Point(w_2, 0), new Point(w, 0), new Point(w, h), new Point(w_2, h)], {
        fill_color: [253, 253, 253, 255],
        stroke_color: [0, 0, 0, 0]
      });
      p_o.stroke(143, 114, 93, 120);
      p_o.strokeWeight(6);
      p_o.line(w_2, 0, w_2, h);
      p_o.stroke("black");
      p_o.strokeWeight(1);
      p_o.fill(85, 185, 102, 60);
      p_o.stroke(17, 74, 27, 180);
      ref6 = input_points.map(function(p) {
        return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100);
      });
      for (z = 0, len5 = ref6.length; z < len5; z++) {
        p = ref6[z];
        p_o.ellipse(p.x, p.y, 10, 10);
      }
      p_o.stroke(143, 114, 93, 120);
      ref7 = zonoid_lines.map(function(l) {
        return [new Point(l.start.x * (scale_factor * 2) + w * 0.75, l.start.y * scale_factor + 100), new Point(l.end.x * (scale_factor * 2) + w * 0.75, l.end.y * scale_factor + 100)];
      });
      for (i1 = 0, len6 = ref7.length; i1 < len6; i1++) {
        l_i = ref7[i1];
        p_o.line(l_i[0].x, l_i[0].y, l_i[1].x, l_i[1].y);
      }
      for (j1 = 0, len7 = zonoid_temp.length; j1 < len7; j1++) {
        z_i = zonoid_temp[j1];
        p_o.fill(16, 74, 34, 180);
        p_o.stroke(16, 74, 34, 255);
        p_o.ellipse(z_i.x, z_i.y, 20, 20);
        p_o.ellipse(z_i.x, z_i.y, 10, 10);
      }
      if (zonoid_temp.length > 0) {
        return draw_poly(p_o, zonoid_temp, {
          fill_color: [78, 185, 120, 160],
          stroke_color: [16, 74, 34, 255]
        });
      }
    };
    canvas_mouseWheel = function(event) {
      var j, len, p_i, zonoid_dual_vertices;
      if (event.deltaY > 0) {
        k -= 1;
      } else if (event.deltaY < 0) {
        k += 1;
      }
      if (k < 2) {
        k = 2;
      }
      if (k > dual_lines.length) {
        k = dual_lines.length;
      }
      slider.value(k);
      label.html("<b>K:</b> " + k);
      k_level_u = compute_k_level(dual_lines, k, {
        reverse: true
      });
      reflex_vertices_u = compute_reflex_vertices(k_level_u, {
        up: false
      });
      zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, {
        up: false
      });
      k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1, {
        reverse: true
      });
      reflex_vertices_d = compute_reflex_vertices(k_level_d, {
        up: true
      });
      zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, {
        up: true
      });
      zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d);
      zonoid_lines = [];
      for (j = 0, len = zonoid_dual_vertices.length; j < len; j++) {
        p_i = zonoid_dual_vertices[j];
        zonoid_lines.push(new Line(new Point(-10000, -p_i.x * -10000 + p_i.y), new Point(10000, -p_i.x * 10000 + p_i.y), -p_i.x, p_i.y));
      }
      k_level_u_temp = k_level_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_u_temp = reflex_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      k_level_d_temp = k_level_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_d_temp = reflex_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_u_temp = zonoid_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_d_temp = zonoid_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid = compute_zonoid(input_points, {
        k: k - 1
      });
      zonoid_temp = zonoid.map(function(p) {
        return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100);
      });
      return zonoid_temp = radial_sort(zonoid_temp, {
        anchor: leftmost_point(zonoid_temp),
        cw: true
      });
    };
    draw_poly = function(p_o, points, arg) {
      var fill_color, j, len, p_i, ref, stroke_color;
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
      for (j = 0, len = points.length; j < len; j++) {
        p_i = points[j];
        p_o.vertex(p_i.x, p_i.y);
      }
      p_o.endShape(p_o.CLOSE);
      p_o.fill("black");
      return p_o.stroke("black");
    };
    return select_event = function() {
      var j, len, p_i, zonoid_dual_vertices;
      k = slider.value();
      label.html("<b>K:</b> " + k);
      k_level_u = compute_k_level(dual_lines, k, {
        reverse: true
      });
      reflex_vertices_u = compute_reflex_vertices(k_level_u, {
        up: false
      });
      zonoid_vertices_u = compute_zonoid_vertices_from_reflex(reflex_vertices_u, dual_lines, {
        up: false
      });
      k_level_d = compute_k_level(dual_lines, dual_lines.length - k + 1, {
        reverse: true
      });
      reflex_vertices_d = compute_reflex_vertices(k_level_d, {
        up: true
      });
      zonoid_vertices_d = compute_zonoid_vertices_from_reflex(reflex_vertices_d, dual_lines, {
        up: true
      });
      zonoid_dual_vertices = zonoid_vertices_u.concat(zonoid_vertices_d);
      zonoid_lines = [];
      for (j = 0, len = zonoid_dual_vertices.length; j < len; j++) {
        p_i = zonoid_dual_vertices[j];
        zonoid_lines.push(new Line(new Point(-10000, -p_i.x * -10000 + p_i.y), new Point(10000, -p_i.x * 10000 + p_i.y), -p_i.x, p_i.y));
      }
      k_level_u_temp = k_level_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_u_temp = reflex_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      k_level_d_temp = k_level_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      reflex_vertices_d_temp = reflex_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_u_temp = zonoid_vertices_u.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid_vertices_d_temp = zonoid_vertices_d.map(function(p) {
        return new Point(p.x * scale_factor, p.y * scale_factor);
      });
      zonoid = compute_zonoid(input_points, {
        k: k - 1
      });
      zonoid_temp = zonoid.map(function(p) {
        return new Point(p.x * (scale_factor * 2) + w * 0.75, p.y * scale_factor + 100);
      });
      return zonoid_temp = radial_sort(zonoid_temp, {
        anchor: leftmost_point(zonoid_temp),
        cw: true
      });
    };
  };

  zonoid_k_levels_p5 = new p5(zonoids_k_level_demo, "demo-zonoid-k-levels-canvas");

}).call(this);
