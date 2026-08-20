// In Revision

// ============================================================================
// CLOVER CAM - TRUSS-LOCAL BASAL MODULE
// ============================================================================
// Truss-specific basal module: the clover-shaped cam profile used by strut
// ends and connection pockets. Do not call directly - use truss_canon() instead.
// ============================================================================

module truss_clover_cam(base_radius, base_radius_addendum, cam_factor, height, point_count){
    //the average radius of the connection cam shape is the strut end radius plus a small clearance addendum.
    final_base_radius = base_radius + base_radius_addendum;
    //we use a polar function to define how the radius changes with angle
    function calc_radius(theta) = final_base_radius - cam_factor*cos(4*theta - 180);
    //we convert to cartesian coordinates using x = r*cos(theta), y = r*sin(theta)
    function cartesian_pair(theta) = [calc_radius(theta)*cos(theta), calc_radius(theta)*sin(theta)];
    //points is an array of xy coordinate pairs, used to make the polygon for the connection cam shape.
    // In preview mode, use fewer points for faster display
    preview_point_count = $preview ? min(point_count, 20) : point_count;
    points = [for (a = [0: 360 / preview_point_count : 360-(360 / preview_point_count)]) cartesian_pair(a)];

    linear_extrude(height=height, convexity=2)polygon(points);
}
