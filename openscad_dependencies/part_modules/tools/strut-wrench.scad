// Not Yet Productive
// Strut Wrench — Tool for turning truss struts into locked position
//
// A flat wrench with an open-ended mouth sized to grip a strut,
// providing leverage for the 90-degree twist that locks struts into hubs.

module strut_wrench(
    mouth_width = 4,          // Opening width (strut body_height + clearance)
    mouth_depth = 6,          // How deep the mouth extends into the body
    body_length = 50,         // Overall length of the wrench
    head_length = 10,         // Length of the head (X direction)
    head_width = 10,          // Width of the head (Y direction)
    handle_width = 5,         // Width of the handle
    mouth_radius = 1,         // Rounding on mouth entrance edges
    body_height = 50,         // body_height
    chamfer_depth = 0.8
){
    $fn = 30;

    minkowski(){
        linear_extrude(height = body_height - 2*chamfer_depth)
        difference(){
            union(){
                // Head — square centered at origin
                offset(r = -chamfer_depth)
                translate([-head_length/2, -head_width/2])
                square([head_length, head_width]);

                // Handle
                offset(r = -chamfer_depth)
                translate([-body_length + head_length/2, -handle_width/2])
                square([body_length - head_length/2, handle_width]);
            }
            // Mouth opening — extends from +X edge into head, with rounded entrance
            offset(r = mouth_radius)
            offset(r = -mouth_radius)
            offset(r = chamfer_depth)
            translate([head_length/2 - mouth_depth, -mouth_width/2])
            square([mouth_depth + 1, mouth_width]);
        }
        octahedron(chamfer_depth);
    }
}
