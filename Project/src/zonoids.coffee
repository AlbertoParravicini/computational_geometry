# # Import classes
# {Point, KSetElem} = require('./utils.coffee')
# # Import functions
# {swap, squared_distance, orientation_test} = require('./utils.coffee')

a = new Point(2, 3)



b = new KSetElem(4,5,0.1)

console.log _.isEqual(a, a)

console.log b
console.log squared_distance(a, new Point(2,3))

compute_k_sets = (S, {k} = {}) ->
  k ?= 1

  n_points = S.length
  k_sets = []

  # Handle case where n_points == k 
  if n_points == k
    for p in S 
      k_sets.push(new KSetElem(p.x, p.y, 1 / k))
      return k_sets

  # If n_points != k, consider the line passing every pair of points
  for i in [0..n_points - 1]
    for j in [i..n_points]
      if i != j

        # Sets containing the points on the left and in the right of i-j, respectively. 
        set_left = []
        set_right = []

        console.log "----------------\n\n"
        console.log "considering line i: ", S[i], " -- j; ", S[j], "\n"
        for n in [1..n_points - 1]
          # Test the position of every other point w.r.t. the line passing thourgh i and j,
          # and put the point in the appropriate set. 
          if (n != i) and (n != j) 
            pos = orientation_test(S[i], S[j], S[n])
            if pos > 0
              set_left.push(new KSetElem(S[n].x, S[n].y, 1 / k))
            else if pos < 0
              set_right.push(new KSetElem(S[n].x, S[n].y, 1 / k))

            console.log "evaluating point n: ", S[n], "  ", "position: ", pos, " -- ", if pos > 0 then "left" else "right", "\n"
        
        console.log "set left: ", set_left, "\n"
        console.log "set right: ", set_right, "\n"

        # Process set_left
        if set_left.length > 0
          # Handle case with k = nrow(S) - 1, return all points except the 1-set 
          if (k == S.length) and (set_left.length == 1) 
            set_right.push(new KSetElem(S[i].x, S[i].y, 1 / k))
            set_right.push(new KSetElem(S[j].x, S[j].y, 1 / k))
            k_sets.push(set_right)
          # Case where the set has the desired length
          else if set_left.length == k
            k_sets.push(set_left)
        

        # Process set_right
        if set_left.length > 0
          # Handle case with k = nrow(S) - 1, return all points except the 1-set 
          if (k == S.length) and (set_left.length == 1) 
            set_right.push(new KSetElem(S[i].x, S[i].y, 1 / k))
            set_right.push(new KSetElem(S[j].x, S[j].y, 1 / k))
            k_sets.push(set_right)
          # Case where the set has the desired length
          else if set_left.length == k
            k_sets.push(set_left)
        


S = [
  new Point(1, 3),
  new Point(4, 2),
  new Point(8, 2),
  new Point(9, 4),
  new Point(2, 5),
  new Point(4, 3),
  new Point(6, 4)
]



console.log S
 
k = 1

k_sets = compute_k_sets(S, k)
console.log k_sets

