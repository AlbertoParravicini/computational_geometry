input_points = [new Point(300, 200), new Point(423, 100), new Point(100, 300), new Point(200, 400), new Point(100, 400), new Point(240, 320), new Point(280, 150)];
convex_hull = []
setup = () ->
    createCanvas(640, 480)
    fill('black')

draw = () -> 
    background(200)
    for p_i in input_points
        ellipse(p_i.x, p_i.y, 4, 4)

    if convex_hull.length > 2
        for i in [0..convex_hull.length - 2]
            line(convex_hull[i].x, convex_hull[i].y, convex_hull[i + 1].x, convex_hull[i + 1].y)
        line(convex_hull[convex_hull.length - 1].x, convex_hull[convex_hull.length - 1].y, convex_hull[0].x, convex_hull[0].y)

mousePressed = () ->
    input_points.push(new Point(mouseX, mouseY))

keyPressed = () ->
    convex_hull = convex_hull_graham_scan(input_points)
    console.log "size: ", convex_hull.length, "\nhull: ", convex_hull, "\n"

