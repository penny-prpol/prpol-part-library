// Not Yet Productive
// Nut Wrench — Tool for tightening M3 nuts in PRPOL assemblies
//
// A cylindrical socket with a hex pocket for the nut and a 3.3mm
// thruhole for the bolt, with a flat handle extending from the base.

module nut_wrench(
    nut_width = 5.7,          // M3 nut flat-to-flat width
    nut_clearance = 0.3,      // Clearance for easy fit
    socket_depth = 3,         // Depth of hex pocket
    socket_wall = 1.5,        // Wall thickness around socket
    socket_height = 20,       // Total height of the cylinder
    thruhole_diameter = 3.4,  // Bolt pass-through hole
    handle_length = 60,       // Length of handle
    handle_width = 12,        // Width of handle
    handle_thickness = 5,     // Thickness of flat handle
    chamfer_depth = 0.6
){
    $fn = 30;

    nut_circumscribed = (nut_width + nut_clearance) / cos(30);
    socket_outer_d = nut_circumscribed + socket_wall * 2;

    difference(){
        minkowski(){
            union(){
                // Socket cylinder
                translate([0, 0, chamfer_depth])
                cylinder(d = socket_outer_d - 2*chamfer_depth, h = socket_height - 2*chamfer_depth);

                // Flat handle extending from base
                translate([chamfer_depth, -socket_outer_d/2 + chamfer_depth, chamfer_depth])
                cube([handle_length - 2*chamfer_depth, socket_outer_d - 2*chamfer_depth, handle_thickness - 2*chamfer_depth]);
            }
            octahedron(chamfer_depth);
        }

        // Hex pocket from the top
        translate([0, 0, socket_height - socket_depth])
        cylinder(d = nut_circumscribed, h = socket_depth + 1, $fn = 6);

        // Thruhole through entire cylinder
        translate([0, 0, -1])
        cylinder(d = thruhole_diameter, h = socket_height + 2);
    }
}
