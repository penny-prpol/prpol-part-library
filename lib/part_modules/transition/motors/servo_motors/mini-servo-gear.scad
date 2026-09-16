// Mini servo gear.
//
// A size 1 spur gear whose bore matches the splined output horn of a
// mini servo, so it presses straight onto the horn.
//
// The gear body and its chamfers come from plain_spur_gear(), which
// reaches this file through the include chain in prpol-header.scad.

module mini_servo_gear(
    horn_bumps = 20,
    horn_dip = 0.2,
    horn_fudge_factor = 0.2,
    measured_horn_diameter = 4.83,
    echo_parameters = true
){
    if (echo_parameters) {
        echo(str("mini_servo_gear(horn_bumps=", horn_bumps, ", horn_dip=", horn_dip, ", horn_fudge_factor=", horn_fudge_factor, ", measured_horn_diameter=", measured_horn_diameter, ")"));
    }
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

    // Gear body: size 1 spur gear. plain_spur_gear() generates the
    // teeth and the top/bottom chamfers.
    gear_height = 8;
    bore_diameter = 2.2;

    // Bore and horn cutouts, measured from the bottom of the gear.
    shaft_bore_diameter = 5.5;
    shaft_bore_height = gear_height - 2.5 - 2.5; // = 3
    horn_start_height = gear_height - 2.5;       // = 5.5

    render()
    difference(){
        plain_spur_gear(
            size = 1,
            thickness = gear_height,
            axis_bore_diameter = bore_diameter,
            do_nut_pocket = false,
            echo_parameters = false
        );

        cylinder(d = shaft_bore_diameter, h = shaft_bore_height);
        translate([0, 0, horn_start_height])
        linear_extrude(height = 10, center = false, convexity = 10, twist = 0)
        polygon(horn_polygon_points);
    }
}
