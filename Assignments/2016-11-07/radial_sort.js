function setup() {
    createCanvas(640, 480);
    fill('black');
}

class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
}

var points = [];

function mousePressed() {
    points.push(new Point(mouseX, mouseY));
}

function keyPressed() {
    radial_sort(points)
}

squared_distance = function (a, b) {
    return Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2);
};


orientation_test = function (p, q, r) {
    var determinant;
    determinant = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x);
    if (determinant === 0) {
        return 0;
    } else if (determinant > 0) {
        return 1;
    } else {
        return -1;
    }
};


radial_sort = function (points, anchor, ccw) {
    if (anchor == null) {
        anchor = null;
    }
    if (ccw == null) {
        ccw = false;
    }
    if (points.length === 0) {
        return [];
    }
    if (anchor === null) {
        anchor = points[0];
    }
    points.sort(function (a, b) {
        var orientation;
        if (a.x - anchor.x === 0 && a.y - anchor.y === 0) {
            return false;
        }
        if (a.x - anchor.x >= 0 && b.x - anchor.x < 0) {
            return a.y - anchor.y < 0;
        }
        if (a.y - anchor.y < 0 && b.y - anchor.y >= 0) {
            return true;
        }
        if (a.y - anchor.y >= 0 && b.y - anchor.y < 0) {
            return false;
        } else if (a.y - anchor.y === 0 && b.y - anchor.y === 0) {
            if (a.x - anchor.x >= 0 || b.x - anchor.x >= 0) {
                return a.x < b.x;
            } else {
                b.x < a.x;
            }
        }
        orientation = orientation_test(anchor, a, b);
        if (orientation === 0) {
            return squared_distance(anchor, a) >= squared_distance(anchor, b);
        } else {
            return orientation < 0;
        }
    });

    if (ccw) {
        return points.reverse();
    }
};

var points = [new Point(300, 200), new Point(200, 100), new Point(100, 300), new Point(200, 400), new Point(100, 400), new Point(240, 320), new Point(280, 150)];
function draw() {
    background(200);
    for (i in points) {
        ellipse(points[i].x, points[i].y, 4, 4);
    }

    for (i = 0; i < points.length - 1; i++) {
        line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
    }
    line(points[points.length - 1].x, points[points.length - 1].y, points[0].x, points[0].y)
}      