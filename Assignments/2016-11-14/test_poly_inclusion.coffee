input_points = [];

drawing_polygon_done = false

query_point = false

result = false

w= 1200
h = 800

setup = () ->
    canvas = createCanvas(w, h)
    canvas.parent('sketch-holder')
    fill('black') 

draw = () -> 
    background(230)
    line(0, h / 2, w, h / 2)
    line(w / 2, 0, w / 2, h)
    fill("black");
    stroke("black");
    for p_i in input_points
        ellipse(p_i.x, p_i.y, 4, 4)

    if input_points.length >= 2
        if !drawing_polygon_done
            for i in [0..input_points.length - 2] 
                line(input_points[i].x, input_points[i].y, input_points[i + 1].x, input_points[i + 1].y)

            
    if drawing_polygon_done      
        result = if check_inclusion_in_polygon(input_points, new Point(mouseX, mouseY)) then "INSIDE" else "OUTSIDE"
        if result == "INSIDE"
            fill("green");
            stroke("green");
        else
            fill("red");
            stroke("red");
        ellipse(mouseX, mouseY, 15, 15)
        line(0, mouseY, w, mouseY)
        fill("black");
        stroke("black");
        draw_shape(input_points)


mousePressed = () ->
    if !drawing_polygon_done
        new_point = new Point(mouseX, mouseY)
        if input_points.length > 2
            close_enough = (new_point.x - input_points[0].x) ** 2 + (new_point.y - input_points[0].y) ** 2 <= h / 2 
            if close_enough
                if check_self_intersection_new_point(input_points, input_points[0])
                    console.log new_point, "creates a self-intersection!"
                else 
                    drawing_polygon_done = true
                    # Note that the HTML5 canvas is flipped on the y axis, so the result must be inverted!
                    direction = if simple_polygon_orientation_clockwise(input_points) then "counter-clockwise" else "clockwise"
                    console.log "direction: ", direction, "\n"
            else 
                if check_self_intersection_new_point(input_points, new_point)
                    console.log new_point, "creates a self-intersection!"
                else input_points.push(new_point)
        else input_points.push(new_point)


keyPressed = () -> 
    if input_points.length > 2 and !drawing_polygon_done
        if check_self_intersection_new_point(input_points, input_points[0])
            console.log "Closing the polygon creates a self-intersection!"
        else
            drawing_polygon_done = true
            # Note that the HTML5 canvas is flipped on the y axis, so the result must be inverted!
            direction = if simple_polygon_orientation_clockwise(input_points) then "counter-clockwise" else "clockwise"
            console.log "direction: ", direction, "\n"

draw_shape = (points) ->
    if result == "INSIDE"
        fill(153, 255, 153, 40)
    else 
        fill(255, 179, 179, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y);
    endShape(CLOSE)
   


    

    


