//Twistlinks is a hub-and-strut truss system.
//The default size is 100 mm from the center of one hub to the next.
//With this standard sizing, "leg" struts are 86 mm long,
//And diagonal "hyp" (hypotenuse) struts are 127.421 mm long.

//To connect a strut to a hub, simply insert it and then twist it 90 degrees.

include <strut.scad>
include <hub.scad>


cube_width = 20;
connection_depth = 3;
slop = 0.3; // Clearance addendum to all diameters in connection shafts
thruhole_diameter = 3.2;

side_length = cube_width * tan(22.5);
layer_cutoff = side_length / sqrt(2);

strut_legs_width = 4;
strut_toes_width = 5.7; //default 5.5
strut_thickness = 3;
leg_separation = 0.5;
leg_separation_depth = 8; //originally 3

cylinder_faces = 40;

center_to_center = 100;
leg_strut_length = center_to_center - cube_width + (2 * connection_depth);
hyp_strut_length = (sqrt(2) * center_to_center) - cube_width + (2 * connection_depth);

strut_body_width = 5;

//helper modules

module truss_set(
    do_nut_pockets = true,
    nut_thickness = 2.6,
    nut_width = 5.7
){
    translate([0,0,10])
    hub(
        do_nut_pockets = do_nut_pockets,
        nut_thickness = nut_thickness,
        nut_width = nut_width
    );

    translate([30,0,strut_thickness / 2])leg_strut();

    translate([40,0,strut_thickness / 2])hyp_strut();
}

