input_edges_points = [];

result = false

start_point = false
end_point = false

res = 0


w= 1200
h = 800


setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(230)
    fill("black");
    stroke("black");
    line(0, h / 2, w, h / 2)
    line(w / 2, 0, w / 2, h)

    if start_point
        ellipse(start_point.x, start_point.y, 4, 4)
    for p_i in input_edges_points
        ellipse(p_i.x, p_i.y, 4, 4)
    i = 0
    while i < input_edges_points.length
        line(input_edges_points[i].x, input_edges_points[i].y, input_edges_points[i + 1].x, input_edges_points[i + 1].y)
        i += 2 
    fill("red");
    stroke("red");
    for i_i in res
        ellipse(i_i.x, i_i.y, 8, 8)
    fill("black");
    stroke("black");

mousePressed = () ->
    if !start_point
        start_point = new PointEdge(mouseX, mouseY)
    else
        end_point = new PointEdge(mouseX, mouseY)
        temp_edge = new Edge(start_point, end_point)
        input_edges_points.push(start_point, end_point)
        start_point = false



keyPressed = () -> 
    if input_edges_points.length >= 2 
       
        res = sweep_line_intersection(input_edges_points)
        console.log "INTERSECTIONS: ", res
        console.log "\n\n\SIZE:", res.length



    

    

