//needs work: top chamfering is off

// Mini servo gear.
//
// A spur gear whose bore matches the splined output horn of a mini
// servo, so it presses straight onto the horn.
//
// Uses spur_gear() from the vendor gears library, which reaches this
// file through the include chain in prpol-header.scad.

module mini_servo_gear(
    horn_bumps = 20,
    horn_dip = 0.2,
    horn_fudge_factor = 0.2,
    measured_horn_diameter = 4.83
){
    $fn = 50;

    // Horn spline polygon, cut through the top of the gear.
    outer_horn_diameter = measured_horn_diameter + horn_fudge_factor;
    inner_horn_diameter = outer_horn_diameter - horn_dip*2;

    outer_horn_radius = outer_horn_diameter / 2;
    inner_horn_radius = inner_horn_diameter / 2;

    bump_angle = 360 / (horn_bumps*2);
    horn_polygon_points = [for (i = [0 : (2*horn_bumps)-1])
        [(inner_horn_radius + (horn_dip*(i % 2)))*cos(i*bump_angle),
         (inner_horn_radius + (horn_dip*(i % 2)))*sin(i*bump_angle)]];

    // Gear body: module 1 spur gear with 10 teeth.
    gear_height = 8;
    chamfer_depth = 2;
    pitch_diameter = 10;
    chamfer_radius = 1.5 + (pitch_diameter / 2);
    bore_diameter = 2.2;

    // Bore and horn cutouts, measured from the bottom of the gear.
    shaft_bore_diameter = 5.5;
    shaft_bore_height = gear_height - 2.5 - 2.5; // = 3
    horn_start_height = gear_height - 2.5;       // = 5.5

    module gear_body(){
        difference(){
            spur_gear(
                module_size = 1,
                tooth_number = 10,
                width = gear_height,
                bore = bore_diameter,
                pressure_angle = 25,
                helix_angle = 0,
                optimized = false
            );

            // Chamfer the top edge.
            translate([0, 0, gear_height-chamfer_depth]){
                difference(){
                    cylinder(r=chamfer_radius, h=gear_height);
                    cylinder(r1=chamfer_radius, r2=0, h=chamfer_depth);
                }
            }

            // Chamfer the bottom edge.
            translate([0, 0, 0-gear_height+chamfer_depth]){
                difference(){
                    cylinder(r=chamfer_radius, h=gear_height);
                    translate([0, 0, 0-chamfer_radius+gear_height])
                    cylinder(r1=0, r2=chamfer_radius, h=chamfer_radius);
                }
            }
        }
    }

    difference(){
        gear_body();
        cylinder(d=shaft_bore_diameter, h=shaft_bore_height);
        translate([0, 0, horn_start_height])
        linear_extrude(height = 10, center = false, convexity = 10, twist = 0)
        polygon(horn_polygon_points);
    }
}
