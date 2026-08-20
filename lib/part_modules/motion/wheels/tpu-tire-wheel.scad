// In Revision

// TPU Tire + Rigid Wheel
//
// A two-part wheel assembly: a rigid printed wheel core and a flexible
// TPU tire that snaps into a channel around the rim.
//
// The tire and wheel are rendered in different colours so they are
// easy to distinguish in the preview.  When exporting for printing,
// render the wheel and tire separately.

module tpu_tire_wheel(
    size = 7,
    tire_cross_section = 3,        // radius of the tire's rounded profile
    wheel_thickness = 8,           // thickness of the rigid wheel core
    axis_bore_diameter = 3.2,
    nut_clearance = 0.1,
    nut_width = 5.5,
    nut_thickness = 2.25,
    hub_diameter = 14,
    spoke_count = 4,
    spoke_width = 4
){
    //DERIVED VALUES (NO TOUCHY)
    wheel_diameter = size * 10;
    // The tire sits in a channel cut into the rim.
    // Channel floor diameter = wheel_diameter - 2 * tire_cross_section
    channel_diameter = wheel_diameter - 2 * tire_cross_section;
    // Tire centreline (torus major radius)
    tire_major_radius = channel_diameter / 2 + tire_cross_section;
    inner_diameter = channel_diameter - 6;
    increment_angle = 360 / spoke_count;
    nut_circumscribed_diameter = nut_width / cos(30);
    // Raised lip on each side of the rim to retain the tire
    lip_height = tire_cross_section * 0.6;
    lip_thickness = 1.5;

    $fn = 80;

    // ── Rigid wheel core ──────────────────────────────
    color("#6B3F69")
    difference(){
        union(){
            // Rim with raised lips on both sides
            // Bottom lip (z = 0)
            cylinder(d = wheel_diameter, h = lip_height);
            // Top lip (z = wheel_thickness - lip_height)
            translate([0, 0, wheel_thickness - lip_height])
            cylinder(d = wheel_diameter, h = lip_height);
            // Rim body (in the channel area)
            difference(){
                cylinder(d = wheel_diameter, h = wheel_thickness);
                // Cut the channel for the tire
                translate([0, 0, lip_height])
                cylinder(d = channel_diameter,
                         h = wheel_thickness - 2 * lip_height);
            }

            // Spokes
            for(i = [0 : spoke_count - 1]){
                rotate(i * increment_angle, [0, 0, 1])
                translate([0, -spoke_width / 2, 0])
                cube([inner_diameter / 2 + lip_thickness,
                      spoke_width, wheel_thickness]);
            }

            // Central hub
            cylinder(d = hub_diameter, h = wheel_thickness);
        }

        // Axis bore
        cylinder(d = axis_bore_diameter, h = 100, center = true);

        // Lock screw hole and nut pocket
        rotate(360 / (2 * spoke_count), [0, 0, 1]){
            translate([0, 0, wheel_thickness / 2])
            rotate(90, [0, 1, 0])
            cylinder(h = size * 10, d = 3.2);

            translate([2.2, -(nut_width + nut_clearance) / 2,
                       wheel_thickness - (wheel_thickness / 2 + nut_circumscribed_diameter / 2)]){
                cube([nut_thickness + nut_clearance,
                      nut_width + nut_clearance,
                      wheel_thickness / 2 + nut_circumscribed_diameter / 2]);
            }
        }
    }

    // ── TPU tire ──────────────────────────────────────
    color("#333333")
    translate([0, 0, wheel_thickness / 2])
    rotate_extrude(convexity = 10)
    translate([tire_major_radius, 0, 0])
    circle(r = tire_cross_section);

}
