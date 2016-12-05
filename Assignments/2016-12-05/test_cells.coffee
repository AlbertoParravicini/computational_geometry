
query_point = false

drawing_points_done = false

lines = false
inter = false
res = false

w= 1200
h = 800

input_points = []

cell = false

cells = false


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    # line(0, h / 2, w, h / 2)
    # line(w / 2, 0, w / 2, h)
    fill("black");
    stroke("black");


    for p in input_points
        ellipse(p.x, p.y, 10, 10)

    
    # if query_point
    #     fill(255, 212, 73);
    #     stroke(255, 212, 73);
    #     ellipse(query_point.x, query_point.y, 14, 14)

    # if res
    #     fill("black");
    #     stroke("black");
    #     for l in lines
    #         ellipse(l[0].x, l[0].y, 10, 10)
    #         ellipse(l[1].x, l[1].y, 10, 10)
    #         line(l[0].x, l[0].y, l[1].x, l[1].y)

    #     fill("red");
    #     stroke("red");
    #     for l in res
    #         ellipse(l[0].x, l[0].y, 14, 14)
    #         ellipse(l[1].x, l[1].y, 14, 14)
    #         line(l[0].x, l[0].y, l[1].x, l[1].y)

    #     fill("green");
    #     stroke("green");
    #     for p in cell   
    #         ellipse(p.x, p.y, 18, 18)

    #     for l in inter
    #         line(query_point.x, query_point.y,  0.9 * l.x + 0.1 * query_point.x, 0.9 * l.y + 0.1 * query_point.y)
    #     draw_poly(radial_sort(cell, query_point))
    # fill("black");
    # stroke("black");

    if cells
        for i in [0...cells.length]
            draw_poly(radial_sort(cells[i], input_points[i]))

   

mousePressed = () ->
    if !drawing_points_done
        input_points.push(new Point(mouseX, mouseY))
    
    else
        #query_point = new Point(mouseX, mouseY)

        #[lines, res, inter, cell] = find_cell(input_points, query_point)
        cells = find_cells(input_points)


keyPressed = () -> 
    drawing_points_done = true
    cells = find_cells(input_points)
      

draw_poly = (points) ->

    fill(123, 23,76, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   


    

    


