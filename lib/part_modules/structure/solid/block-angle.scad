// Final Review
// Block Angle — Solid right-angle bracket for structural corners
// 
// A robust L-shaped bracket with two rectangular arm extrusions at a
// configurable angle. Optional hole patterns for bolting, optional
// chamfers for smoothness, and nut pockets on the radial bolt axes.
//
// Use: Structural corner piece, connecting two parts at a specified angle
// Examples: 
//   - Corner brace in truss towers
//   - Chassis corner mount for robots
//   - Internal structural support

module block_angle(
    length1 = 5,              // Length of first arm in PRPOL units (X direction)
    length2 = 5,              // Length of second arm in PRPOL units
    angle = 45,               // Angle between arms (degrees)
    height = 1,               // Height in PRPOL units (1 unit = 10mm)
    hole_diameter = 3.2,      // Diameter of mounting holes
    chamfer_depth = 0.6,  
    do_nut_pockets = true,
    nut_thickness=2.5,
    nut_width=5.5,
    nut_clearance=0.2,
){
    $fn = 30;
    body_height = height * 10;

    nut_circumscribed_diameter = nut_width / cos(30);
    nut_pocket_width = nut_thickness + nut_clearance;
    nut_pocket_length = nut_width + nut_clearance;
    nut_pocket_height = 5 + nut_circumscribed_diameter/2 + 1;

    difference(){
        union(){
            hull(){
                global_chamfer_cylinder(d = 10, h = body_height, chamfer_depth = chamfer_depth);

                translate([(length1 - 1)*10 - 5, -5, 0])
                global_chamfer_cube([10, 10, body_height], chamfer_depth = chamfer_depth);
            }
            rotate(angle)
            hull(){
                global_chamfer_cylinder(d = 10, h = body_height, chamfer_depth = chamfer_depth);

                translate([(length2 - 1)*10 - 5, -5, 0])
                global_chamfer_cube([10, 10, body_height], chamfer_depth = chamfer_depth);
            }
        }
        //center hole
        translate([0,0, -1]) 
        cylinder(d =  hole_diameter, h = body_height + 2);

        //holes along x axis
        for(i = [1 : length1 - 1]){
            translate([10 * i, 0 , -1])
            cylinder(d =  hole_diameter, h = body_height + 2);
        }

        // vertical holes along radial arm
        for(i = [1 : length2 - 1]){
            translate(
                [10 * i * cos(angle),
                10 * i * sin(angle),
                -1]
            )
            cylinder(d =  hole_diameter, h = body_height + 2);

        }

        for(j = [0 : height - 1]){
            translate([0,0,5 + 10*j])
            rotate(90,[1,0,0])
            for(i = [1 : length1 - 1]){
                translate([10 * i, 0 , 0])
                cylinder(d =  hole_diameter, h = 10 + 0.1, center = true);
            }
        }
        
        rotate(angle)
        for(j = [0 : height - 1]){
            translate([0,0,5 + 10*j])
            rotate(90,[1,0,0])
            for(i = [1 : length2 - 1]){
                translate([10 * i, 0 , 0])
                cylinder(d =  hole_diameter, h = 10 + 0.1, center = true);
            }
        }

        // radial holes along arm 1 (X direction)
        for(j = [0 : height - 1]){
            translate([-0.05, 0, 5 + 10*j])
            rotate([0, 90, 0])
            cylinder(d = hole_diameter, h = length1 * 10 + 0.1);
        }

        // radial holes along arm 2
        rotate(angle)
        for(j = [0 : height - 1]){
            translate([-0.05, 0, 5 + 10*j])
            rotate([0, 90, 0])
            cylinder(d = hole_diameter, h = length2 * 10 + 0.1);
        }

        // nut pockets at ends of radial arms
        if(do_nut_pockets){
            // arm 1 nut pockets (opening -Y / leftward)
            for(j = [0 : height - 1]){
                translate([(length1-1.5)*10 - nut_pocket_width/2,
                            -5 - 1,
                            5 + 10*j - nut_pocket_length/2])
                cube([nut_pocket_width, nut_pocket_height, nut_pocket_length]);
            }

            // arm 2 nut pockets (opening +Y / rightward in arm's local frame)
            rotate(angle)
            for(j = [0 : height - 1]){
                translate([(length2-1.5)*10 - nut_pocket_width/2,
                            5 - nut_pocket_height + 1,
                            5 + 10*j - nut_pocket_length/2])
                cube([nut_pocket_width, nut_pocket_height, nut_pocket_length]);
            }
        }
    }
}

