drawing_points_done = false



w= 1200
h = 800

r1 = Math.random()
r2 = Math.random()
r3 = Math.random()

input_points = []

cell = false
lines = false
res = false
inter = false


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    fill("black");
    stroke("black");


    for p in input_points
        ellipse(p.x, p.y, 10, 10)

    if cell
        fill("black");
        stroke("black");
        for l in res
            ellipse(l[0].x, l[0].y, 14, 14)
            ellipse(l[1].x, l[1].y, 14, 14)
            line(l[0].x, l[0].y, l[1].x, l[1].y)
        draw_poly(radial_sort(cell, input_points[input_points.length - 1]))

   

mousePressed = () ->

    input_points.push(new Point(mouseX, mouseY))
    
    if input_points.length > 1
       [lines, res, inter, cell] = find_cell(input_points, input_points[input_points.length - 1])



      

draw_poly = (points) ->

    coord = 0
    for p in points
        coord += p.x + p.y
    fill((coord * r1) %% 256, (coord * r2) %% 256, (coord * r3) %% 256, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   


    

    


