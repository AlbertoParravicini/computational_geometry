input_points = [new Point(180, 118), new Point(300, 200), new Point(423, 200), new Point(100, 300), new Point(350, 120), 
    new Point(200, 320), new Point(200, 340),new Point(450, 350), new Point(150, 390),
    new Point(220, 400), new Point(240, 320), new Point(280, 450)];

new_point = new Point(320, 240)

for i in [0...input_points.length]
    input_points[i].x += 400

hull = convex_hull_graham_scan(input_points)

res = false

w= 1200
h = 800

setup = () ->
    createCanvas(w, h)
    fill('black') 

draw = () -> 
    background(200)
    scale(1, -1);
    line(0, h / 2, w, h / 2)
    line(w / 2, 0, w / 2, h)
    fill("green");
    stroke("green");
    ellipse(new_point.x, new_point.y, 8, 8)
    ellipse(hull[0].x, hull[0].y, 8, 8)
    fill("black");
    stroke("black");
    for p_i in hull
        ellipse(p_i.x, p_i.y, 4, 4)

    if hull.length > 2
        for i in [0..hull.length - 2]
            line(hull[i].x, hull[i].y, hull[i + 1].x, hull[i + 1].y)
        #line(hull[hull.length - 1].x, hull[hull.length - 1].y, hull[0].x, hull[0].y)

        for i in [2..hull.length - 2]
            stroke("red")
            line(hull[0].x, hull[0].y, hull[i].x, hull[i].y)
            stroke("black")

    if res 
        stroke("green");
        line(new_point.x, new_point.y, res[1].x, res[1].y)
        stroke("red");
        line(new_point.x, new_point.y, res[2].x, res[2].y)
        stroke("black");
 
mousePressed = () ->
    new_point = new Point(mouseX, mouseY)
    res = false

keyPressed = () -> 
   res = find_tangents_bin_search(hull, new_point)
   if !res
    console.log "result: ", res, "\n"


