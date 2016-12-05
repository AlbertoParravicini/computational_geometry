// Generated by CoffeeScript 1.11.1
var Point, area_of_triangle, build_cell, check_intersection, compute_intersections, convex_hull_graham_scan, create_line, create_line_from_m_q, epsilon, find_bisecting_line_parameters, find_cell, find_cells, find_lines, h, orientation_test, radial_sort, squared_distance, swap, translate_back, translate_to_origin, turn_lines_to_polar_point, turn_polar_points_to_lines, w;

w = 1200;

h = 800;

epsilon = 0.000001;

Point = (function() {
  Point.prototype.x = 0.0;

  Point.prototype.y = 0.0;

  function Point(x1, y1) {
    this.x = x1;
    this.y = y1;
  }

  Point.prototype.toString = function() {
    return "Point(" + this.x + ", " + this.y + ")\n";
  };

  return Point;

})();

swap = function(list, index_1, index_2) {
  var temp;
  temp = list[index_1];
  list[index_1] = list[index_2];
  return list[index_2] = temp;
};

squared_distance = function(a, b) {
  return Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2);
};

area_of_triangle = function(a, b, c, abs, divide) {
  var res;
  if (abs == null) {
    abs = true;
  }
  if (divide == null) {
    divide = true;
  }
  res = (a.x * b.y) + (a.y * c.x) + (b.x * c.y) - (b.y * c.x) - (c.y * a.x) - (b.x * a.y);
  if (divide === true) {
    res = (1 / 2) * res;
  }
  if (abs === true) {
    res = Math.abs(res);
  }
  return res;
};

orientation_test = function(p, q, r) {
  var determinant;
  determinant = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x);
  return determinant;
};

radial_sort = function(points, anchor, cw) {
  if (points.length === 0) {
    return [];
  }
  if (anchor == null) {
    anchor = new Point(points[0].x, points[0].y);
  }
  if (cw == null) {
    cw = true;
  }
  points.sort(function(a, b) {
    var orientation;
    if (a.x - anchor.x === 0 && a.y - anchor.y === 0 && b.x - anchor.x !== 0 && b.y - anchor.y !== 0) {
      return -1;
    }
    if (a.x - anchor.x !== 0 && a.y - anchor.y !== 0 && b.x - anchor.x === 0 && b.y - anchor.y === 0) {
      return 1;
    }
    if (a.x - anchor.x >= 0 && b.x - anchor.x < 0) {
      return -1;
    }
    if (a.x - anchor.x < 0 && b.x - anchor.x >= 0) {
      return 1;
    }
    if (a.x - anchor.x === 0 && b.x - anchor.x === 0) {
      if (a.y - anchor.y < 0 && b.y - anchor.y < 0) {
        if (a.y < b.y) {
          return 1;
        } else {
          return -1;
        }
      } else {
        if (a.y > b.y) {
          return 1;
        } else {
          return -1;
        }
      }
    }
    orientation = orientation_test(anchor, a, b);
    if (orientation === 0) {
      if (squared_distance(anchor, a) >= squared_distance(anchor, b)) {
        return 1;
      } else {
        return -1;
      }
    } else {
      if (orientation > 0) {
        return 1;
      } else {
        return -1;
      }
    }
  });
  if (!cw) {
    points.reverse();
  }
  return points;
};

convex_hull_graham_scan = function(input_points) {
  var anchor, convex_hull, cw, i, k, n, points, ref, ref1, smallest_x_point_index;
  points = input_points.slice();
  convex_hull = [];
  smallest_x_point_index = 0;
  for (i = k = 0, ref = points.length - 1; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
    if ((points[i].x < points[smallest_x_point_index].x) || ((points[i].x === points[smallest_x_point_index].x) && (points[i].y < points[smallest_x_point_index].y))) {
      smallest_x_point_index = i;
    }
  }
  swap(points, 0, smallest_x_point_index);
  anchor = new Point(points[0].x, points[0].y);
  points = [anchor].concat(radial_sort(points.slice(1), anchor, cw = false));
  i = 1;
  while (i < points.length - 1 && (orientation_test(anchor, points[i], points[i + 1]) === 0)) {
    points.splice(i, 1);
  }
  if (points.length < 3) {
    return [];
  }
  convex_hull.push(new Point(points[0].x, points[0].y));
  convex_hull.push(new Point(points[1].x, points[1].y));
  convex_hull.push(new Point(points[2].x, points[2].y));
  for (i = n = 3, ref1 = points.length - 1; 3 <= ref1 ? n <= ref1 : n >= ref1; i = 3 <= ref1 ? ++n : --n) {
    while (orientation_test(convex_hull[convex_hull.length - 2], convex_hull[convex_hull.length - 1], points[i]) <= 0) {
      convex_hull.pop();
    }
    convex_hull.push(new Point(points[i].x, points[i].y));
  }
  return convex_hull;
};

create_line_from_m_q = function(m, q) {
  var end_y, start_y;
  if (Math.abs(q) <= 0.1) {
    q = 0;
  }
  if (m === 0) {
    return [new Point(0, q), new Point(w, q)];
  }
  start_y = q;
  end_y = m * w + q;
  if (start_y >= 0 && start_y <= h) {
    if (end_y >= 0 && end_y <= h) {
      return [new Point(0, start_y), new Point(w, end_y)];
    } else if (end_y < 0) {
      return [new Point(0, start_y), new Point(-q / (m + epsilon), 0)];
    } else {
      return [new Point(0, start_y), new Point((h - q) / (m + epsilon), h)];
    }
  }
  if (start_y < 0) {
    if (end_y >= 0 && end_y <= h) {
      return [new Point(-q / (m + epsilon), 0), new Point(w, end_y)];
    } else if (end_y > 0) {
      return [new Point(-q / (m + epsilon), 0), new Point((h - q) / (m + epsilon), h)];
    } else {
      return console.log("ERROR!");
    }
  } else {
    if (end_y >= 0 && end_y <= h) {
      return [new Point((h - q) / (m + epsilon), h), new Point(w, end_y)];
    } else if (end_y < 0) {
      return [new Point((h - q) / (m + epsilon), h), new Point(-q / (m + epsilon), 0)];
    } else {
      return console.log("ERROR!");
    }
  }
};

create_line = function(p_1, p_2) {
  var m, q;
  m = (p_2.y - p_1.y) / (p_2.x - p_1.x);
  q = (p_1.y * p_2.x - p_2.y * p_1.x) / (p_2.x - p_1.x);
  return create_line_from_m_q(m, q);
};

translate_to_origin = function(input_lines, point) {
  var k, l, len, len1, lines, n;
  lines = [];
  for (k = 0, len = input_lines.length; k < len; k++) {
    l = input_lines[k];
    lines.push([new Point(l[0].x, l[0].y), new Point(l[1].x, l[1].y)]);
  }
  for (n = 0, len1 = lines.length; n < len1; n++) {
    l = lines[n];
    l[0].x -= point.x;
    l[0].y -= point.y;
    l[1].x -= point.x;
    l[1].y -= point.y;
  }
  return lines;
};

translate_back = function(input_lines, point) {
  var k, l, len, len1, lines, n;
  lines = [];
  for (k = 0, len = input_lines.length; k < len; k++) {
    l = input_lines[k];
    lines.push([new Point(l[0].x, l[0].y), new Point(l[1].x, l[1].y)]);
  }
  for (n = 0, len1 = lines.length; n < len1; n++) {
    l = lines[n];
    l[0].x += point.x;
    l[0].y += point.y;
    l[1].x += point.x;
    l[1].y += point.y;
  }
  return lines;
};

turn_lines_to_polar_point = function(input_lines) {
  var a, b, k, l, len, polar_points, x_1, x_2, y_1, y_2;
  polar_points = [];
  for (k = 0, len = input_lines.length; k < len; k++) {
    l = input_lines[k];
    x_1 = l[0].x;
    x_2 = l[1].x;
    y_1 = l[0].y;
    y_2 = l[1].y;
    a = (y_1 - y_2) / (y_1 * x_2 - y_2 * x_1 + epsilon);
    b = (x_2 - x_1) / (y_1 * x_2 - y_2 * x_1 + epsilon);
    polar_points.push(new Point(a, b));
  }
  return polar_points;
};

turn_polar_points_to_lines = function(input_points) {
  var a, b, k, len, lines, m, p, q;
  lines = [];
  for (k = 0, len = input_points.length; k < len; k++) {
    p = input_points[k];
    a = p.x;
    b = p.y;
    m = -a / (b + epsilon);
    q = 1 / (b + epsilon);
    lines.push([new Point(0, q), new Point(w, m * w + q)]);
  }
  return lines;
};

find_lines = function(input_lines, query_point) {
  var final_output_lines, hull, k, l, len, lines, output_lines, polar_points, temp_line;
  lines = translate_to_origin(input_lines, query_point);
  polar_points = turn_lines_to_polar_point(lines);
  hull = convex_hull_graham_scan(polar_points);
  output_lines = turn_polar_points_to_lines(hull);
  output_lines = translate_back(output_lines, query_point);
  final_output_lines = [];
  for (k = 0, len = output_lines.length; k < len; k++) {
    l = output_lines[k];
    temp_line = create_line(l[0], l[1]);
    if (temp_line[0].y < 0) {
      temp_line[0].y = 0;
    }
    if (temp_line[1].y < 0) {
      temp_line[1].y = 0;
    }
    if (Math.abs(temp_line[0].x - temp_line[1].x) < 1) {
      temp_line[0].y = 0;
      temp_line[1].y = h;
    }
    final_output_lines.push(temp_line);
  }
  return final_output_lines;
};

check_intersection = function(edge_1, edge_2) {
  var m1, m2, o1, o2, o3, o4, p_11, p_12, p_21, p_22, q1, q2, x, y;
  if (edge_1 === null || edge_1 === void 0 || edge_2 === null || edge_2 === void 0) {
    return false;
  }
  p_11 = new Point(edge_1[0].x, edge_1[0].y);
  p_12 = new Point(edge_1[1].x, edge_1[1].y);
  p_21 = new Point(edge_2[0].x, edge_2[0].y);
  p_22 = new Point(edge_2[1].x, edge_2[1].y);
  m1 = (p_12.y - p_11.y) / (p_12.x - p_11.x + epsilon);
  m2 = (p_22.y - p_21.y) / (p_22.x - p_21.x + epsilon);
  if (Math.abs(m1) > 1000) {
    if (p_11.x < 0.1 && p_12.x < 0.1) {
      p_11.x = 0.01;
      p_12.x = 0.01;
    } else if (p_11.x > w - 0.1 && p_12.x > w - 0.1) {
      p_11.x = w - 0.01;
      p_12.x = w - 0.01;
    }
    p_11.y = 0;
    p_12.y = h;
  }
  if (Math.abs(m2) > 1000) {
    if (p_21.x < 0.1 && p_22.x < 0.1) {
      p_21.x = 0.01;
      p_22.x = 0.01;
    } else if (p_21.x > w - 0.1 && p_22.x > w - 0.1) {
      p_21.x = w - 0.01;
      p_22.x = w - 0.01;
    }
    p_21.y = 0;
    p_22.y = h;
  }
  o1 = orientation_test(p_11, p_12, p_21);
  o2 = orientation_test(p_11, p_12, p_22);
  o3 = orientation_test(p_21, p_22, p_11);
  o4 = orientation_test(p_21, p_22, p_12);
  if (o1 * o2 <= 0 && o3 * o4 <= 0) {
    m1 = (p_12.y - p_11.y) / (p_12.x - p_11.x + epsilon);
    m2 = (p_22.y - p_21.y) / (p_22.x - p_21.x + epsilon);
    q1 = (p_11.y * p_12.x - p_12.y * p_11.x) / (p_12.x - p_11.x + epsilon);
    q2 = (p_21.y * p_22.x - p_22.y * p_21.x) / (p_22.x - p_21.x + epsilon);
    x = (q2 - q1) / (m1 - m2 + epsilon);
    y = (m1 * q2 - m2 * q1) / (m1 - m2 + epsilon);
    return new Point(x, y);
  }
  return false;
};

compute_intersections = function(input_lines) {
  var i, intersection, intersections, j, k, n, ref, ref1;
  intersections = [];
  for (i = k = 0, ref = input_lines.length; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
    for (j = n = 0, ref1 = input_lines.length; 0 <= ref1 ? n <= ref1 : n >= ref1; j = 0 <= ref1 ? ++n : --n) {
      if (j > i) {
        intersection = check_intersection(input_lines[i], input_lines[j]);
        if (intersection) {
          intersections.push(intersection);
        }
      }
    }
  }
  return intersections;
};

build_cell = function(intersections, input_lines, query_point) {
  var approx_p, cell, int_flag, k, l, len, len1, n, no_intersection, p, segment;
  cell = [];
  for (k = 0, len = intersections.length; k < len; k++) {
    p = intersections[k];
    no_intersection = true;
    approx_p = new Point(0.99 * p.x + 0.01 * query_point.x, 0.99 * p.y + 0.01 * query_point.y);
    segment = [approx_p, query_point];
    for (n = 0, len1 = input_lines.length; n < len1; n++) {
      l = input_lines[n];
      int_flag = check_intersection(segment, l);
      if (int_flag) {
        no_intersection = false;
        break;
      }
    }
    if (no_intersection) {
      cell.push(p);
    }
  }
  return cell;
};

radial_sort = function(points, anchor, cw) {
  if (points.length === 0) {
    return [];
  }
  if (anchor == null) {
    anchor = new Point(points[0].x, points[0].y);
  }
  if (cw == null) {
    cw = true;
  }
  points.sort(function(a, b) {
    var orientation;
    if (a.x - anchor.x === 0 && a.y - anchor.y === 0 && b.x - anchor.x !== 0 && b.y - anchor.y !== 0) {
      return -1;
    }
    if (a.x - anchor.x !== 0 && a.y - anchor.y !== 0 && b.x - anchor.x === 0 && b.y - anchor.y === 0) {
      return 1;
    }
    if (a.x - anchor.x >= 0 && b.x - anchor.x < 0) {
      return -1;
    }
    if (a.x - anchor.x < 0 && b.x - anchor.x >= 0) {
      return 1;
    }
    if (a.x - anchor.x === 0 && b.x - anchor.x === 0) {
      if (a.y - anchor.y < 0 && b.y - anchor.y < 0) {
        if (a.y < b.y) {
          return 1;
        } else {
          return -1;
        }
      } else {
        if (a.y > b.y) {
          return 1;
        } else {
          return -1;
        }
      }
    }
    orientation = orientation_test(anchor, a, b);
    if (orientation === 0) {
      if (squared_distance(anchor, a) >= squared_distance(anchor, b)) {
        return 1;
      } else {
        return -1;
      }
    } else {
      if (orientation > 0) {
        return 1;
      } else {
        return -1;
      }
    }
  });
  if (!cw) {
    points.reverse();
  }
  return points;
};

find_bisecting_line_parameters = function(p_1, p_2) {
  var m, q;
  m = (p_1.x - p_2.x) / (p_2.y - p_1.y + epsilon);
  q = (p_1.y + p_2.y) / 2 - m * (p_1.x + p_2.x) / 2;
  return [m, q];
};

find_cell = function(input_points, query_point) {
  var cell, inter, k, len, lines, m, p_i, q, ref, res;
  lines = [[new Point(0, 0), new Point(0, h)], [new Point(0, h), new Point(w, h)], [new Point(w, h), new Point(w, 0)], [new Point(w, 0), new Point(0, 0)]];
  for (k = 0, len = input_points.length; k < len; k++) {
    p_i = input_points[k];
    if (p_i.x !== query_point.x && p_i.y !== query_point.y) {
      ref = find_bisecting_line_parameters(query_point, p_i), m = ref[0], q = ref[1];
      lines.push(create_line_from_m_q(m, q));
    }
  }
  res = find_lines(lines, query_point);
  inter = compute_intersections(res);
  cell = build_cell(inter, res, query_point);
  return [lines, res, inter, cell];
};

find_cells = function(input_points) {
  var cell, cells, k, len, p;
  cells = [];
  for (k = 0, len = input_points.length; k < len; k++) {
    p = input_points[k];
    cell = find_cell(input_points, p)[3];
    cells.push(cell);
  }
  return cells;
};
