// Generated by CoffeeScript 1.12.3
var S, a, b, compute_k_sets, k, k_sets, l, len, m, p, ref, ref1;

a = new Point(2, 3);

b = new KSetElem(4, 5, 0.1);

console.log(_.isEqual(a, a));

console.log(b);

console.log(squared_distance(a, new Point(2, 3)));

compute_k_sets = function(S, arg) {
  var i, j, k, k_sets, l, len, len1, m, n, n_points, o, p, pos, q, r, ref, ref1, ref2, temp_set;
  k = (arg != null ? arg : {}).k;
  if (k == null) {
    k = 1;
  }
  n_points = S.length;
  k_sets = [];
  if (n_points === k) {
    for (l = 0, len = S.length; l < len; l++) {
      p = S[l];
      k_sets.push(new KSetElem(p.x, p.y, 1 / k));
      return k_sets;
    }
  }
  for (i = m = 0, ref = n_points - 1; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
    for (j = o = 0, ref1 = n_points - 1; 0 <= ref1 ? o <= ref1 : o >= ref1; j = 0 <= ref1 ? ++o : --o) {
      if (i !== j) {
        temp_set = [];
        console.log("----------------\n\n");
        console.log("considering line i: ", S[i], " -- j; ", S[j], "\n");
        for (n = q = 0, ref2 = n_points - 1; 0 <= ref2 ? q <= ref2 : q >= ref2; n = 0 <= ref2 ? ++q : --q) {
          if ((n !== i) && (n !== j)) {
            pos = orientation_test(S[i], S[j], S[n]);
            if (pos > 0) {
              temp_set.push(new KSetElem(S[n].x, S[n].y, 1 / k));
            }
            console.log("evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", (pos > 0 ? "left" : "right"), "\n");
          }
        }
        console.log("temp_set: ", temp_set, "\n");
        if (temp_set.length > 0) {
          if ((k === S.length) && (temp_set.length === 1)) {
            for (r = 0, len1 = S.length; r < len1; r++) {
              p = S[r];
              if ((p.x !== temp_set[0].x) && (p.y !== temp_set[0].y)) {
                k_sets.push(new KSetElem(p.x, p.y, 1 / k));
              }
              return k_sets;
            }
          } else if (temp_set.length === k) {
            k_sets.push(temp_set);
          }
        }
      }
    }
  }
  return k_sets;
};

S = [new Point(1, 3), new Point(4, 2), new Point(8, 2), new Point(9, 4), new Point(2, 5), new Point(4, 3), new Point(6, 4)];

console.log(S);

k = 1;

k_sets = compute_k_sets(S, k);

console.log(k_sets);

for (k = l = 0, ref = k_sets.length - 1; 0 <= ref ? l <= ref : l >= ref; k = 0 <= ref ? ++l : --l) {
  console.log("k-set number: ", k, "\n\n");
  ref1 = k_sets[k];
  for (m = 0, len = ref1.length; m < len; m++) {
    p = ref1[m];
    console.log(p);
  }
}

console.log(_.difference([[1, 2], [3, 4], [5, 6]], [1, 2]));
