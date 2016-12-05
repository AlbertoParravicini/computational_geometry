
query_point = false

drawing_points_done = false


w= 1200
h = 800

r1 = Math.random()
r2 = Math.random()
r3 = Math.random()

input_points = []

cells = false


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    fill("black");
    stroke("black");


    for p in input_points
        ellipse(p.x, p.y, 10, 10)

    if cells
        for i in [0...cells.length]
            draw_poly(radial_sort(cells[i], input_points[i]))

   

mousePressed = () ->
    if !drawing_points_done
        input_points.push(new Point(mouseX, mouseY))
    
    else
        cells = find_cells(input_points)


keyPressed = () -> 
    drawing_points_done = true
    cells = find_cells(input_points)
      

draw_poly = (points) ->

    coord = 0
    for p in points
        coord += p.x + p.y
    fill((coord * r1) %% 256, (coord * r2) %% 256, (coord * r3) %% 256, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   


    

    


