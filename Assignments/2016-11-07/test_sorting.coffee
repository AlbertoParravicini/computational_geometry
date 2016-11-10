input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
    new Point(200, 320), new Point(50, 40),new Point(50, 350), new Point(150, 350),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];

input_anchor = new Point(320, 240)

setup = () ->
    createCanvas(640, 480)
    fill('black') 

draw = () -> 
    background(200)
    line(0, 240, 640, 240)
    line(320, 0, 320, 480)
    fill("green");
    stroke("green");
    ellipse(0, 0, 6, 6)
    ellipse(input_anchor.x, input_anchor.y, 10, 10)
    ellipse(input_points[0].x, input_points[0].y, 6, 6)
    stroke(51);
    fill(51);
    for p_i in input_points[1..]
        ellipse(p_i.x, p_i.y, 4, 4)

    if input_points.length > 2
        for i in [0..input_points.length - 2]
            line(input_points[i].x, input_points[i].y, input_points[i + 1].x, input_points[i + 1].y)
        #line(input_points[input_points.length - 1].x, input_points[input_points.length - 1].y, input_points[0].x, input_points[0].y)

mousePressed = () ->
    input_points.push(new Point(mouseX, mouseY))

keyPressed = () ->
   console.log "\n input: ", input_points
   radial_sort(input_points, anchor = null, cw = true)
   console.log "sorted: ", input_points, "\n"
    

