// Generated by CoffeeScript 1.12.3
var zonoids_k_sets_anim_demo, zonoids_k_sets_anim_p5;

zonoids_k_sets_anim_demo = function(p_o) {
  var animation_duration, build_zonoid, canvas_mouseWheel, current_duration, current_k_set, default_color, draw_poly, h, input_points, k, k_set_num, k_sets, m_sep, num_input_points, q_sep, sep_p1, sep_p2, start_animation, w, zonoid;
  input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), new Point(200, 320), new Point(50, 40), new Point(51, 350), new Point(150, 350), new Point(220, 400), new Point(240, 320), new Point(280, 450)];
  default_color = [121, 204, 147, 40];
  num_input_points = 15;
  h = 480;
  w = 640;
  k = 3;
  k_set_num = 0;
  zonoid = [];
  build_zonoid = true;
  current_k_set = 0;
  animation_duration = 6;
  current_duration = 0;
  start_animation = false;
  k_sets = false;
  sep_p1 = false;
  sep_p2 = false;
  m_sep = false;
  q_sep = false;
  p_o.setup = function() {
    var canvas;
    canvas = p_o.createCanvas(w, h);
    p_o.fill('red');
    p_o.frameRate(10);
    canvas.mouseWheel(canvas_mouseWheel);
    k_sets = compute_k_sets_disc_2(input_points, {
      k: k
    });
    sep_p1 = k_sets[current_k_set].separator[0];
    sep_p2 = k_sets[current_k_set].separator[1];
    m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x);
    q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x);
    return zonoid.push(k_sets[current_k_set].mean_point);
  };
  p_o.draw = function() {
    var i, j, l, len, len1, len2, len3, m, p_i, ref, z_i;
    p_o.background(253, 253, 253);
    p_o.fill(85, 185, 102, 60);
    p_o.stroke(17, 74, 27, 180);
    for (i = 0, len = input_points.length; i < len; i++) {
      p_i = input_points[i];
      p_o.ellipse(p_i.x, p_i.y, 10, 10);
    }
    if (p_o.mouseX > 0 && p_o.mouseX < w && p_o.mouseY > 0 && p_o.mouseY < h) {
      start_animation = true;
    }
    if (build_zonoid && start_animation) {
      p_o.strokeWeight(5);
      p_o.stroke(255, 251, 234, Math.floor(255 * (1 - current_duration / animation_duration)));
      p_o.line(0, q_sep, w, m_sep * w + q_sep);
      p_o.stroke(17, 74, 27, Math.floor(180 * (1 - current_duration / animation_duration)));
      p_o.strokeWeight(2);
      p_o.line(0, q_sep, w, m_sep * w + q_sep);
      p_o.strokeWeight(1);
      ref = k_sets[current_k_set].elem_list;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        p_i = ref[j];
        p_o.fill(255, 123, 136, Math.floor(180 * (1 - current_duration / animation_duration)));
        p_o.stroke(130, 65, 104, Math.floor(255 * (1 - current_duration / animation_duration)));
        p_o.ellipse(p_i.x, p_i.y, 10, 10);
        p_o.ellipse(p_i.x, p_i.y, 14, 14);
      }
      p_o.fill(16, 74, 34, 180);
      p_o.stroke(16, 74, 34, 255);
      for (l = 0, len2 = zonoid.length; l < len2; l++) {
        z_i = zonoid[l];
        p_o.ellipse(z_i.x, z_i.y, 10, 10);
        p_o.ellipse(z_i.x, z_i.y, 20, 20);
      }
      if (current_k_set < k_sets.length - 1) {
        if (current_duration >= animation_duration) {
          current_k_set += 1;
          current_duration = 0;
          sep_p1 = k_sets[current_k_set].separator[0];
          sep_p2 = k_sets[current_k_set].separator[1];
          m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x);
          q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x);
          return zonoid.push(k_sets[current_k_set].mean_point);
        } else {
          return current_duration += 1;
        }
      } else {
        build_zonoid = false;
        return current_duration = 0;
      }
    } else {
      for (m = 0, len3 = zonoid.length; m < len3; m++) {
        z_i = zonoid[m];
        p_o.fill(16, 74, 34, 180);
        p_o.stroke(16, 74, 34, 255);
        p_o.ellipse(z_i.x, z_i.y, 20, 20);
        p_o.ellipse(z_i.x, z_i.y, 10, 10);
      }
      if (zonoid.length > 0) {
        draw_poly(p_o, radial_sort(zonoid, {
          anchor: leftmost_point(zonoid),
          cw: true
        }));
        draw_poly(p_o, zonoid, {
          fill_color: [78, 185, 120, Math.floor(160 * current_duration / animation_duration)],
          stroke_color: [16, 74, 34, 255]
        });
      }
      if (current_duration < animation_duration) {
        return current_duration += 1;
      }
    }
  };
  canvas_mouseWheel = function(event) {
    if (!build_zonoid && current_duration === animation_duration) {
      if (event.deltaY > 0) {
        k -= 1;
      } else if (event.deltaY < 0) {
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
      current_k_set = 0;
      sep_p1 = k_sets[current_k_set].separator[0];
      sep_p2 = k_sets[current_k_set].separator[1];
      m_sep = (sep_p2.y - sep_p1.y) / (sep_p2.x - sep_p1.x);
      q_sep = (sep_p1.y * sep_p2.x - sep_p2.y * sep_p1.x) / (sep_p2.x - sep_p1.x);
      zonoid = [];
      zonoid.push(k_sets[current_k_set].mean_point);
      build_zonoid = true;
      return current_duration = 0;
    }
  };
  return draw_poly = function(p_o, points, arg) {
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
};

zonoids_k_sets_anim_p5 = new p5(zonoids_k_sets_anim_demo, "demo-zonoid-k-sets-anim-canvas");
