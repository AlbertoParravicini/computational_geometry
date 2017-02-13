rm(list=ls(all=TRUE))

###################################
# ORIENTATION DETERMINANT #########
# Test whether the point "r" lies on the left or on the right
# of the line passing for points "p" and "q".
# Based on "http://dccg.upc.edu/people/vera/wp-content/uploads/2013/06/GeoC-OrientationTests.pdf",
# pages 5-6.
orientation_test <- function(p, q, r) {
  #console.log p, q, r
  determinant = (q[1] - p[1]) * (r[2] - p[2]) - (q[2] - p[2]) * (r[1] - p[1])
  # determinant == 0: p, q, r are on the same line
  # determinant > 0: r is on the left of p and q (counter-clockwise turn)
  # determinant < 0: r is on the right of p and q (clockwise turn)
  #console.log "det:", determinant, "\n"
  return(determinant)
}
  
# Check if the matrix A is contained in the list of matrices B
in_set <- function(A, B) {
  for (B_i in B) {
    if (setequal(A, B_i)) {
      return(T)
    }
  }
  return(F)
}

# compute the k-sets of a set of points S
compute_k_sets <- function(S, k = 1) {
  n_points = nrow(S)
  
  k_sets = list()
  
  # Case where k == nrow(S)
  if (k == nrow(S)) {
    return(list(S))
  }
  
  # If n_points != k, consider the line passing every pair of points
  for (i in 1:(n_points - 1)) {
    for (j in i:n_points) {
      if (i != j) {
        
        # Sets containing the points on the left and in the right of i-j, respectively. 
        set_left = c()
        set_right = c()
        
        #cat("---------------------\n\n")
        #cat("considering line i: ", S[i, ], " -- j; ", S[j, ], "\n")
        for (n in 1:n_points) {
          # Test the position of every other point w.r.t. the line passing thourgh i and j,
          # and put the point in the appropriate set.
          if (!(n %in% c(i, j))){
            pos = orientation_test(S[i, ], S[j, ], S[n, ])
            if (pos > 0) {
              set_left = c(set_left, S[n, ])
            }
            else if (pos < 0) {
              set_right = c(set_right, S[n, ])
            }
        
            #cat("evaluating point n: ", S[n, ], "  ")
            #cat("position: ", pos, " -- ", if(pos > 0) "left" else "right", "\n")
          }
        }
        #cat("set left: ", set_left, "\n")
        #cat("set right: ", set_right, "\n")
        

        if (!is.null(set_left)) {
          set_left = matrix(set_left, ncol = ncol(S), byrow = T)
          
          #Handle case with k = nrow(S) - 1, return all points except the current one
          if (k == nrow(S) - 1 && nrow(set_left) == 1 && !in_set(matrix(c(set_right, t(S[c(i,j), ])), ncol = ncol(S), byrow = T), k_sets)) {
            k_sets = c(k_sets, list(matrix(c(set_right, t(S[c(i,j), ])), ncol = ncol(S), byrow = T)))
          }
          else if (nrow(set_left) == k && !in_set(set_left, k_sets)) {
            #cat("ADDING: ", set_left, "\n")
            k_sets = c(k_sets, list(set_left))
          }
        }
        
        if (!is.null(set_right)) {
          set_right = matrix(set_right, ncol = ncol(S), byrow = T)
          
          #Handle case with k = nrow(S) - 1, return all points except the current one
          if (k == nrow(S) - 1 && nrow(set_right) == 1 && !in_set(matrix(c(set_left, t(S[c(i,j), ])), ncol = ncol(S), byrow = T), k_sets)) {
            k_sets = c(k_sets, list(matrix(c(set_left, t(S[c(i,j), ])), ncol = ncol(S), byrow = T)))
          }
          else if (nrow(set_right) == k && !in_set(set_right, k_sets)) {
            #cat("ADDING: ", set_right, "\n")
            k_sets = c(k_sets, list(set_right))
          }
        }
      }
    }
  }
  return((k_sets))
}

compute_zonoid <- function(S, k = 1) {
  k_sets = compute_k_sets(S, k)
  
  zonoid = c()

  for (i in 1:length(k_sets)) {
    #cat("computing vertex of: ", k_sets[[i]], "\n")
    
    zonoid_vertex = apply(k_sets[[i]], MARGIN = 2, mean)
    #cat("vertex: ", zonoid_vertex, "\n")
    zonoid = c(zonoid, zonoid_vertex)
  }
  if (!is.null(zonoid)) {
    return(matrix(c(zonoid), ncol = ncol(S), byrow=T))
  }
}









S = matrix(c(1, 3, 4, 2, 8, 2, 9, 4, 2, 5, 4, 3, 6, 4), ncol = 2, byrow = T)

S = matrix(rnorm(100, mean = c(0,0)), ncol = 2, byrow = T)

k = 49

plot(S, col = "blue", cex = 1)

k_sets = compute_k_sets(S, k)
k_sets

#points((matrix(unlist(k_sets), ncol=2, byrow=T)), col = "red", cex=3)

zonoid = compute_zonoid(S, k)
points(zonoid, col = "green", cex=4)
k_sets
zonoid


