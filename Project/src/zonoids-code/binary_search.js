// Generated by CoffeeScript 1.12.3
var a, binary_search, default_comparator, zonoid_depth, zonoid_inclusion_comparator;

default_comparator = function(points, value, middle) {
  if (points[middle] < value) {
    return 1;
  } else if (points[middle] > value) {
    return -1;
  } else {
    return 0;
  }
};

zonoid_inclusion_comparator = function(points, value, middle) {
  if ((middle + 1) <= Math.floor(value)) {
    return 1;
  } else {
    return -1;
  }
};

binary_search = function(points, value, arg) {
  var comparator, force_return, middle, ref, res, start, stop;
  ref = arg != null ? arg : {}, comparator = ref.comparator, force_return = ref.force_return, start = ref.start, stop = ref.stop;
  if (comparator == null) {
    comparator = default_comparator;
  }
  if (force_return == null) {
    force_return = false;
  }
  if (start == null) {
    start = 0;
  }
  if (stop == null) {
    stop = points.length - 1;
  }
  while (start < stop) {
    middle = Math.floor((start + stop) / 2);
    res = comparator(points, value, middle);
    if (res > 0) {
      start = middle + 1;
    } else if (res < 0) {
      stop = middle;
    } else {
      return middle;
    }
  }
  if (!force_return) {
    return false;
  } else {
    return Math.floor((start + stop) / 2);
  }
};

a = [1, 2, 3, 4, 5, 6];

zonoid_depth = binary_search(a, 1, {
  comparator: zonoid_inclusion_comparator,
  force_return: true
});

console.log("zonoid depth: ", zonoid_depth);