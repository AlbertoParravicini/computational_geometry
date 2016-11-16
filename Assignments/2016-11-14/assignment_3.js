// Generated by CoffeeScript 1.11.1
var Point, check_horizontal_intersection, check_inclusion_in_polygon, check_self_intersection_new_point, orientation_test, simple_polygon_orientation_clockwise, squared_distance, swap,
  modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

Point = (function() {
  Point.prototype.x = 0.0;

  Point.prototype.y = 0.0;

  function Point(x, y) {
    this.x = x;
    this.y = y;
  }

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

orientation_test = function(p, q, r) {
  var determinant;
  determinant = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x);
  return determinant;
};

simple_polygon_orientation_clockwise = function(input_simple_polygon) {
  var area, i, j, points, ref;
  if (input_simple_polygon.length < 3) {
    throw new Error("the size of the input polygon is ", input_simple_polygon.length);
  }
  points = input_simple_polygon.slice().concat(input_simple_polygon[0]);
  area = 0;
  for (i = j = 1, ref = points.length; 1 <= ref ? j < ref : j > ref; i = 1 <= ref ? ++j : --j) {
    area += (points[i].x - points[i - 1].x) * (points[i].y + points[i - 1].y);
  }
  if (area > 0) {
    return true;
  } else {
    return false;
  }
};

check_self_intersection_new_point = function(input_points_list, new_point) {
  var i, j, o1, o2, o3, o4, points, ref;
  if (input_points_list.length < 2) {
    return false;
  }
  if (input_points_list.length === 2 && orientation_test(input_points_list[0], input_points_list[1], new_point) !== 0) {
    return false;
  }
  points = input_points_list.slice();
  for (i = j = 1, ref = points.length - 2; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
    o1 = orientation_test(points[i - 1], points[i], points[points.length - 1]);
    o2 = orientation_test(points[i - 1], points[i], new_point);
    o3 = orientation_test(points[points.length - 1], new_point, points[i - 1]);
    o4 = orientation_test(points[points.length - 1], new_point, points[i]);
    if (o1 * o2 < 0 && o3 * o4 < 0) {
      return true;
    }
  }
  return false;
};

check_horizontal_intersection = function(p_1, p_2, query_point) {
  var a, b, ref;
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
