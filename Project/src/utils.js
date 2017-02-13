// Generated by CoffeeScript 1.12.3
var KSetElem, Point, orientation_test, radial_sort, squared_distance, swap,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

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
    }
  });
  if (!cw) {
    points.reverse();
  }
  return points;
};