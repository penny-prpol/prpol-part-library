module cloverCam(baseRadius, baseRadiusAddendum, camFactor, height, pointCount){
    //the average radius of the connection cam shape is the strut end radius plus a small clearance addendum.
    finalBaseRadius = baseRadius + baseRadiusAddendum;
    //we use a polar function to define how the radius changes with angle
    function calcRadius(theta) = finalBaseRadius- camFactor*cos(4*theta - 180);
    //we convert to cartesian coordinates using x = r*cos(theta), y = r*sin(theta)
    function cartesianPair(theta) = [calcRadius(theta)*cos(theta),calcRadius(theta)*sin(theta)];
    //points is an array of xy coordinate pairs, used to make the polygon for the connection cam shape.
    points = [for (a = [0: 360 / pointCount : 360-(360 / pointCount)]) cartesianPair(a)];

    linear_extrude(height=height, convexity=2)polygon(points);
}