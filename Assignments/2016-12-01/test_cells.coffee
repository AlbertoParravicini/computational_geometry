
query_point = false

drawing_lines_done = false

start_point = false
end_point = false

res = false
inter = false

w= 1200
h = 800

input_lines = [[new Point(0,0), new Point(0, h)], 
               [new Point(0, h), new Point(w, h)],
               [new Point(w, h), new Point(w, 0)],
               [new Point(w, 0), new Point(0, 0)]]

cell = false


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    # line(0, h / 2, w, h / 2)
    # line(w / 2, 0, w / 2, h)
    fill("black");
    stroke("black");

    if start_point and !query_point
        ellipse(start_point.x, start_point.y, 10, 10)


    for l in input_lines
        ellipse(l[0].x, l[0].y, 10, 10)
        ellipse(l[1].x, l[1].y, 10, 10)
        line(l[0].x, l[0].y, l[1].x, l[1].y)
    
    
    if query_point
        fill(255, 212, 73);
        stroke(255, 212, 73);
        ellipse(query_point.x, query_point.y, 14, 14)

    if res
        fill("red");
        stroke("red");
        for l in res
            ellipse(l[0].x, l[0].y, 14, 14)
            ellipse(l[1].x, l[1].y, 14, 14)
            line(l[0].x, l[0].y, l[1].x, l[1].y)
        fill("green");
        stroke("green");
        for p in cell   
            ellipse(p.x, p.y, 18, 18)

        for l in inter
            line(query_point.x, query_point.y,  0.9 * l.x + 0.1 * query_point.x, 0.9 * l.y + 0.1 * query_point.y)
        draw_poly(radial_sort(cell, query_point))
    fill("black");
    stroke("black");

   

mousePressed = () ->
    if !drawing_lines_done
        if !start_point
            start_point = new Point(mouseX, mouseY)
        else
            end_point = new Point(mouseX, mouseY)
            
            new_line = create_line(start_point, end_point)
            input_lines.push(new_line)
            start_point = false
    
    else
        query_point = new Point(mouseX, mouseY)

        res = find_lines(input_lines, query_point)
        inter = compute_intersections(res)
        cell = build_cell(inter, res, query_point)




keyPressed = () -> 
    drawing_lines_done = true
      

draw_poly = (points) ->

    fill(123, 23,76, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   


    

    


