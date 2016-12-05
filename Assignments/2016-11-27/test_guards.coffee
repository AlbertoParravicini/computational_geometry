input_points = [];

drawing_polygon_done = false

query_point = false

result = false

triangles = false

guards = []

w= 1200
h = 800

r1 = Math.random()
r2 = Math.random()
r3 = Math.random()

setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    line(0, h / 2, w, h / 2)
    line(w / 2, 0, w / 2, h)
    fill("black");
    stroke("black");
    for p_i in input_points
        ellipse(p_i.x, p_i.y, 4, 4)
        
    if !triangles
        if input_points.length >= 2
            for i in [0..input_points.length - 2] 
                line(input_points[i].x, input_points[i].y, input_points[i + 1].x, input_points[i + 1].y)
        if drawing_polygon_done
            line(input_points[0].x, input_points[0].y, input_points[input_points.length - 1].x, input_points[input_points.length - 1].y)
                    
            
    if triangles  
        for i in [0...triangles.length]
            draw_triangle(triangles[i])

        for p in input_points
            if p.color == 1
                fill(255, 51, 51);
                stroke(255, 51, 51);
            else if p.color == 2
                fill(0, 102, 255);
                stroke(0, 102, 255);
            else if p.color == 3
                fill(51, 204, 51);
                stroke(51, 204, 51);
            else 
                fill("brown");
                stroke("brown");
            ellipse(p.x, p.y, 6, 6)


        for p in guards
            fill(255, 212, 73);
            stroke(255, 212, 73);
            ellipse(p.x, p.y, 14, 14)
        fill("black");
        stroke("black");

mousePressed = () ->
    if !drawing_polygon_done
        new_point = new PointColor(mouseX, mouseY)
        if input_points.length > 2
            close_enough = (new_point.x - input_points[0].x) ** 2 + (new_point.y - input_points[0].y) ** 2 <= h / 2 
            if close_enough
                if check_self_intersection_new_point(input_points, input_points[0])
                    console.log new_point, "creates a self-intersection!"
                else 
                    drawing_polygon_done = true
                    # Note that the HTML5 canvas is flipped on the y axis, so the result must be inverted!
                    triangles = triangle_decomposition(input_points)
                    adj_list = create_adj_list(triangles)
                    tricolor_triangulation(adj_list)
                    guards = place_guards(input_points)
                    #triangles = triangle_decomposition(input_points)
                    console.log "dec:" , triangles     
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

    if drawing_polygon_done       
        triangles = triangle_decomposition(input_points)
        adj_list = create_adj_list(triangles)
        tricolor_triangulation(adj_list)
        guards = place_guards(input_points)
        console.log "dec:" , triangles 
        console.log "points:", input_points    


draw_triangle = (points) ->

    coord = points[0].x + points[1].x + points[2].x + points[0].y + points[1].y + points[2].y
    fill((coord * r1) %% 256, (coord * r2) %% 256, (coord * r3) %% 256, 40)
    beginShape()
    for p_i in points 
        vertex(p_i.x, p_i.y)
    endShape(CLOSE)
   


    

    


