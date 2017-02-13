// Generated by CoffeeScript 1.12.3
var S, a, b, compute_k_sets, compute_k_sets_cont, compute_zonoid, in_set, k, k_sets, set_equal, zonoid;

a = new Point(2, 3);

b = new KSetElem(4, 5, 0.1);

console.log(_.isEqual(a, a));

console.log(b);

in_set = function(A, B) {
  var B_i, l, len;
  for (l = 0, len = B.length; l < len; l++) {
    B_i = B[l];
    if (set_equal(A, B_i)) {
      return true;
    }
  }
  return false;
};

set_equal = function(A, B) {
  var flag, l, len, len1, m;
  if (a.length !== b.length) {
    return false;
  }
  for (l = 0, len = A.length; l < len; l++) {
    a = A[l];
    flag = false;
    for (m = 0, len1 = B.length; m < len1; m++) {
      b = B[m];
      if (_.isEqual(a, b)) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      return false;
    }
  }
  return true;
};

compute_k_sets = function(S, arg) {
  var i, j, k, k_sets, l, len, len1, m, n, n_minus_1_set, n_points, n_set, o, p, pos, q, r, ref, ref1, ref2, temp_set;
  k = (arg != null ? arg : {}).k;
  if (k == null) {
    k = 1;
  }
  n_points = S.length;
  k_sets = [];
  if (n_points === k) {
    n_set = [];
    for (l = 0, len = S.length; l < len; l++) {
      p = S[l];
      n_set.push(new KSetElem(p.x, p.y, 1 / k));
    }
    k_sets.push(n_set);
    return k_sets;
  }
  for (i = m = 0, ref = n_points - 1; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
    for (j = o = 0, ref1 = n_points - 1; 0 <= ref1 ? o <= ref1 : o >= ref1; j = 0 <= ref1 ? ++o : --o) {
      if (i !== j) {
        temp_set = [];
        console.log("----------------\n\n");
        console.log("considering line i: ", S[i], " -- j; ", S[j], "\n");
        for (n = q = 0, ref2 = n_points - 1; 0 <= ref2 ? q <= ref2 : q >= ref2; n = 0 <= ref2 ? ++q : --q) {
          if ((n !== i) && (n !== j)) {
            pos = utils.orientation_test(S[i], S[j], S[n]);
            if (pos > 0) {
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k));
            }
            console.log("evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", (pos > 0 ? "left" : "right"), "\n");
          }
        }
        console.log("temp_set: ", temp_set, "\n");
        if (temp_set.length > 0) {
          if ((k === n_points - 1) && (temp_set.length === 1)) {
            n_minus_1_set = [];
            for (r = 0, len1 = S.length; r < len1; r++) {
              p = S[r];
              if ((p.x !== temp_set[0].x) || (p.y !== temp_set[0].y)) {
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 / k));
              } else {
                console.log("rejected:", p);
              }
            }
            if (!in_set(n_minus_1_set, k_sets)) {
              k_sets.push(n_minus_1_set);
            }
          } else if ((temp_set.length === k) && !(in_set(temp_set, k_sets))) {
            k_sets.push(temp_set);
          }
        }
      }
    }
  }
  return k_sets;
};

compute_k_sets_cont = function(S, arg) {
  var i, j, k, k_sets, l, len, len1, m, n, n_minus_1_set, n_points, n_set, o, p, pos, q, r, ref, ref1, ref2, temp_set, temp_set_1, temp_set_2;
  k = (arg != null ? arg : {}).k;
  if (k == null) {
    k = 1;
  }
  n_points = S.length;
  k_sets = [];
  if (n_points === k) {
    n_set = [];
    for (l = 0, len = S.length; l < len; l++) {
      p = S[l];
      n_set.push(new KSetElem(p.x, p.y, 1 / k));
    }
    k_sets.push(n_set);
    return k_sets;
  }
  for (i = m = 0, ref = n_points - 1; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
    for (j = o = 0, ref1 = n_points - 1; 0 <= ref1 ? o <= ref1 : o >= ref1; j = 0 <= ref1 ? ++o : --o) {
      if (i !== j) {
        temp_set = [];
        console.log("----------------\n\n");
        for (n = q = 0, ref2 = n_points - 1; 0 <= ref2 ? q <= ref2 : q >= ref2; n = 0 <= ref2 ? ++q : --q) {
          if ((n !== i) && (n !== j)) {
            pos = orientation_test(S[i], S[j], S[n]);
            if (pos > 0) {
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k));
            }
          }
        }
        if (temp_set.length > 0) {
          if ((Math.floor(k) === n_points - 1) && (temp_set.length === 1)) {
            n_minus_1_set = [];
            for (r = 0, len1 = S.length; r < len1; r++) {
              p = S[r];
              if ((p.x !== temp_set[0].x) || (p.y !== temp_set[0].y)) {
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 / k));
              } else if (Math.floor(k) !== k) {
                n_minus_1_set.push(new KSetElem(p.x, p.y, 1 - Math.floor(k) / k));
              }
            }
            if (!in_set(n_minus_1_set, k_sets)) {
              k_sets.push(n_minus_1_set);
            }
          } else if (Math.floor(k) === k) {
            if ((temp_set.length === k) && !(in_set(temp_set, k_sets))) {
              k_sets.push(temp_set);
            }
          } else {
            temp_set_1 = temp_set.slice();
            temp_set_2 = temp_set.slice();
            temp_set_1.push(new KSetElem(S[i].x, S[i].y, 1 - Math.floor(k) / k));
            temp_set_2.push(new KSetElem(S[j].x, S[j].y, 1 - Math.floor(k) / k));
            if ((temp_set.length === Math.floor(k)) && !in_set(temp_set_1, k_sets)) {
              k_sets.push(temp_set_1);
            }
            if ((temp_set.length === Math.floor(k)) && !in_set(temp_set_2, k_sets)) {
              k_sets.push(temp_set_2);
            }
          }
        }
      }
    }
  }
  return k_sets;
};

compute_zonoid = function(S, arg) {
  var k, k_set_i, k_sets, l, len, len1, m, p_i, v_x, v_y, zonoid;
  k = (arg != null ? arg : {}).k;
  if (k == null) {
    k = 1;
  }
  k_sets = compute_k_sets_cont(S, {
    k: k
  });
  zonoid = [];
  for (l = 0, len = k_sets.length; l < len; l++) {
    k_set_i = k_sets[l];
    v_x = 0;
    v_y = 0;
    for (m = 0, len1 = k_set_i.length; m < len1; m++) {
      p_i = k_set_i[m];
      v_x += p_i.x * p_i.weight;
      v_y += p_i.y * p_i.weight;
    }
    zonoid.push(new Point(v_x, v_y));
  }
  return zonoid;
};

S = [new Point(1, 3), new Point(4, 2), new Point(8, 2), new Point(9, 4), new Point(2, 5), new Point(4, 3), new Point(6, 4)];

console.log(S);

k = 4.3;

k_sets = compute_k_sets_cont(S, {
  k: k
});

console.log(k_sets);

zonoid = compute_zonoid(S, {
  k: k
});
