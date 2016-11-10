input_points = [new Point(100, 10), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(500, 120), 
    new Point(200, 320), new Point(50, 40),new Point(50, 350), new Point(150, 350),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];

new_point = new Point(320, 240)

hull = convex_hull_graham_scan(input_points)

fill_triangle = false

res = false

setup = () ->
    createCanvas(640, 480)
    fill('black') 

draw = () -> 
    background(200)
    line(0, 240, 640, 240)
    line(320, 0, 320, 480)
    fill("green");
    stroke("green");
    ellipse(new_point.x, new_point.y, 8, 8)
    fill("black");
    stroke("black");
    for p_i in hull
        ellipse(p_i.x, p_i.y, 4, 4)

    if hull.length > 2
        for i in [0..hull.length - 2]
            line(hull[i].x, hull[i].y, hull[i + 1].x, hull[i + 1].y)
        line(hull[hull.length - 1].x, hull[hull.length - 1].y, hull[0].x, hull[0].y)

        for i in [2..hull.length - 2]
            stroke("red")
            line(hull[0].x, hull[0].y, hull[i].x, hull[i].y)
            stroke("black")

    if fill_triangle
        console.log res
        fill(255, 204, 0, 80)
        triangle(res[1].x, res[1].y, res[2].x, res[2].y, res[3].x, res[3].y)
        noFill()
 
mousePressed = () ->
    new_point = new Point(mouseX, mouseY)
    fill_triangle = false

keyPressed = () -> 
   res = inclusion_in_hull(hull, new_point)
   if !res
    console.log "result: ", res, "\n"
   else 
    fill_triangle = true
    

