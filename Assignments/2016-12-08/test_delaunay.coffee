
query_point = false

drawing_points_done = false

lines = false
inter = false
res = false

w= 1200
h = 800

input_points = []

edges = false
cells = false

r1 = Math.random()
r2 = Math.random()
r3 = Math.random()


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    # line(0, h / 2, w, h / 2)
    # line(w / 2, 0, w / 2, h)

    fill(Math.floor(r1 * 256), Math.floor(r2 * 256), Math.floor(r3 * 256))
    stroke(Math.floor(r1 * 256), Math.floor(r2 * 256), Math.floor(r3 * 256))
    
    if edges
        for e in edges
            line(e[0].x, e[0].y, e[1].x, e[1].y)
    fill("black");
    stroke("black");

    for p in input_points
        ellipse(p.x, p.y, 10, 10)

    if cells
        for i in [0...cells.length]
            draw_poly(radial_sort(cells[i], input_points[i]))

   

mousePressed = () ->
    input_points.push(new Point(mouseX, mouseY))  


keyPressed = () -> 
    drawing_points_done = true
    cells = find_cells(input_points)
    edges = delaunay_triangulation(input_points)
      

draw_poly = (points) ->

    coord = 0
    for p in points
        coord += p.x + p.y
    fill((coord * r1) %% 256, (coord * r2) %% 256, (coord * r3) %% 256, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   

