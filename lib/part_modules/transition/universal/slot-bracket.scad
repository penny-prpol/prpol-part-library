
/*
    Slot Bracket — used to attach things with arbitrarily-positioned
    mounting holes onto the standard prpol grid. 

    An m3 machine screw goes through the slot of the slot bracket and
    anchors to any standard prpol structural part.

    The nut body of the slot bracket can then be positioned freely by 
    rotating it about the anchor screw and sliding it along the slot.

    The thing you want to attach can then bolt directly to the nut in the
    nut body of the slot bracket.
*/


module slot_bracket(
    slot_length = 8,
    slot_width = 3.2,
    nut_width=5.5,
    nut_clearance=0.2,
    overall_width = 10,
    slot_wall_offset = 3.5,
    plate_thickness = 2.5,
    overall_height = 8,
    nut_ceiling_thickness = 2,
    chamfer_depth = 0.75
){
    nut_circumscribed_diameter = nut_width / cos(30);

    difference(){
        union(){
            hull(){
                //slot body hull target cylinder at origin
                global_chamfer_cylinder(
                    d = overall_width,
                    h = plate_thickness,
                    chamfer_depth = chamfer_depth,
                    $fn=30
                );

                //slot body hull target cylinder offset from origin
                translate([overall_width / 2 + slot_wall_offset + slot_length,0,0])
                global_chamfer_cylinder(
                    d = overall_width,
                    h = plate_thickness,
                    chamfer_depth = chamfer_depth,
                    $fn=30
                );
            }

            //the nut body cylinder (at origin)
            global_chamfer_cylinder(
                    d = overall_width,
                    h = overall_height,
                    chamfer_depth = chamfer_depth,
                    $fn=30
                );
        }

        //cutting bodies

        //the slot
        hull(){
            //the slot hull target nearer to the origin
            translate([overall_width / 2 + slot_wall_offset,0,-1])
            cylinder(d=slot_width, h= plate_thickness * 3, $fn = 20);

            //the slot hull target further away from the origin
            translate([overall_width / 2 + slot_wall_offset + slot_length,0,-1])
            cylinder(d=slot_width, h= plate_thickness * 3, $fn = 20);
        }

        //the nut body through-hole
        translate([0,0,-1])
        cylinder(d = slot_width, h = overall_height * 3, $fn = 20);

        //the hexagonal nut pocket
        translate([0,0,-1])
        cylinder(
            d = nut_circumscribed_diameter + nut_clearance, 
            h = overall_height - nut_ceiling_thickness + 1,
            $fn = 6
        );
    }
}
