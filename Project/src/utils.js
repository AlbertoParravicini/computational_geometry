// Generated by CoffeeScript 1.12.3
var KSet, KSetElem, Line, Point, a, check_horizontal_intersection, check_inclusion_in_polygon, convex_hull_graham_scan, create_line, create_line_from_m_q, epsilon, h, orientation_test, radial_sort, squared_distance, swap, translate_back, translate_to_origin, vertical_coeff, w,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

w = 640;

h = 480;

epsilon = 0.000001;

vertical_coeff = 1;

Point = (function() {
  Point.prototype.x = 0.0;

  Point.prototype.y = 0.0;

  function Point(x, y) {
    this.x = x;
    this.y = y;
  }

  Point.prototype.toString = function() {
    return "Point(" + this.x + ", " + this.y + ")\n";
  };

  return Point;

})();

Line = (function() {
  function Line(start, end, m1, q1) {
    this.start = start;
    this.end = end;
    this.m = m1;
    this.q = q1;
  }

  Line.prototype.toString = function() {
    return "Line( start: " + this.start + " -- end: " + this.end + " -- m: " + this.m + " -- q: " + this.q + ")\n";
  };

  return Line;

})();

KSetElem = (function(superClass) {
  extend(KSetElem, superClass);

  function KSetElem(x, y, weight) {
    this.x = x;
    this.y = y;
    this.weight = weight;
    KSetElem.__super__.constructor.call(this, this.x, this.y);
  }

  KSetElem.prototype.toString = function() {
    return "KSetElem(" + this.x + ", " + this.y + ", -- weight: " + this.weight(+")\n");
  };

  return KSetElem;

})(Point);

KSet = (function() {
  function KSet() {
    this.elem_list = [];
    this.mean_point = new Point(0, 0);
    this.separator = [new Point(0, 0), new Point(0, 0)];
  }

  KSet.prototype.compute_mean = function() {
    var j, len, p, ref;
    ref = this.elem_list;
    for (j = 0, len = ref.length; j < len; j++) {
      p = ref[j];
      this.mean_point.x += p.x;
      this.mean_point.y += p.y;
    }
    this.mean_point.x /= this.elem_list.length;
    return this.mean_point.y /= this.elem_list.length;
  };

  KSet.prototype.toString = function() {
    return "KSet(" + this.elem_list + "\n" + "MEAN: " + this.mean_point + ", -- separator: " + this.separator[0] + ", " + this.separator[1] + ")\n";
  };

  return KSet;

})();

a = new KSet;

console.log(a.separator);

swap = function(list, index_1, index_2) {
  var temp;
  temp = list[index_1];
  list[index_1] = list[index_2];
  return list[index_2] = temp;
};

squared_distance = function(a, b) {
  return Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2);
};

orientation_test = function(p, q, r) {
  var determinant;
  determinant = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x);
  return determinant;
};

radial_sort = function(points, arg) {
  var anchor, cw, ref;
  ref = arg != null ? arg : {}, anchor = ref.anchor, cw = ref.cw;
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

check_horizontal_intersection = function(p_1, p_2, query_point) {
  var b, ref;
  ref = p_1.y < p_2.y ? [p_1, p_2] : [p_2, p_1], a = ref[0], b = ref[1];
  if (query_point.y === a.y || query_point.y === a.y) {
    query_point.y += Number.MIN_VALUE;
  }
  if ((a.y - query_point.y) * (b.y - query_point.y) < 0 && orientation_test(a, b, query_point) < 0) {
    return true;
  } else {
    return false;
  }
};

check_inclusion_in_polygon = function(input_simple_polygon, query_point) {
  var i, intersection_count, j, p_1, p_2, points, ref;
  if (input_simple_polygon.length < 3) {
    throw new Error("the size of the input polygon is ", input_simple_polygon.length);
  }
  points = input_simple_polygon.slice();
  intersection_count = 0;
  for (i = j = 1, ref = points.length; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
    p_1 = points[i - 1];
    p_2 = points[modulo(i, points.length)];
    if (check_horizontal_intersection(p_1, p_2, query_point)) {
      intersection_count += 1;
    }
  }
  return modulo(intersection_count, 2) !== 0;
};

create_line_from_m_q = function(m, q) {
  var end_y, start_y;
  if (Math.abs(q) <= 0.1) {
    q = 0;
  }
  if (m === 0) {
    return new Line(new Point(0, q), new Point(w, q), m, q);
  }
  start_y = q;
  end_y = m * w + q;
  if (start_y >= 0 && start_y <= h) {
    if (end_y >= 0 && end_y <= h) {
      return new Line(new Point(0, start_y), new Point(w, end_y), m, q);
    } else if (end_y < 0) {
      return new Line(new Point(0, start_y), new Point(-q / (m + epsilon), 0), m, q);
    } else {
      return new Line(new Point(0, start_y), new Point((h - q) / (m + epsilon), h), m, q);
    }
  }
  if (start_y < 0) {
    if (end_y >= 0 && end_y <= h) {
      return new Line(new Point(-q / (m + epsilon), 0), new Point(w, end_y), m, q);
    } else if (end_y > 0) {
      return new Line(new Point(-q / (m + epsilon), 0), new Point((h - q) / (m + epsilon), h), m, q);
    } else {
      return console.log("ERROR!");
    }
  } else {
    if (end_y >= 0 && end_y <= h) {
      return new Line(new Point((h - q) / (m + epsilon), h), new Point(w, end_y), m, q);
    } else if (end_y < 0) {
      return new Line(new Point((h - q) / (m + epsilon), h), new Point(-q / (m + epsilon), 0), m, q);
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
  var j, l, len, lines;
  lines = [];
  for (j = 0, len = input_lines.length; j < len; j++) {
    l = input_lines[j];
    lines.push(create_line(new Point(l.start.x - point.x, l.start.y - point.y), new Point(l.end.x - point.x, l.end.y - point.y)));
  }
  return lines;
};

translate_back = function(input_lines, point) {
  var j, l, len, lines;
  lines = [];
  for (j = 0, len = input_lines.length; j < len; j++) {
    l = input_lines[j];
    lines.push(create_line(new Point(l.start.x + point.x, l.start.y + point.y), new Point(l.end.x + point.x, l.end.y + point.y)));
  }
  return lines;
};

convex_hull_graham_scan = function(input_points) {
  var anchor, convex_hull, cw, i, j, k, points, ref, ref1, smallest_x_point_index;
  points = input_points.slice();
  convex_hull = [];
  smallest_x_point_index = 0;
  for (i = j = 0, ref = points.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
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
  for (i = k = 3, ref1 = points.length - 1; 3 <= ref1 ? k <= ref1 : k >= ref1; i = 3 <= ref1 ? ++k : --k) {
    while (orientation_test(convex_hull[convex_hull.length - 2], convex_hull[convex_hull.length - 1], points[i]) <= 0) {
      convex_hull.pop();
    }
    convex_hull.push(new Point(points[i].x, points[i].y));
  }
  return convex_hull;
};
