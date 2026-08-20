// ─────────────────────────────────────────────────────────────────────────────
// DC 130 motor — major-dimensions reference model.
//
// A flattened-cylinder can with its output shaft, for use as a clearance and
// placement reference when designing mounts and brackets. Defaults follow the
// common 130-size hobby motor:
//
//     can diameter        20.0 mm
//     width across flats  18.0 mm
//     can length          25.0 mm
//     output shaft         2.0 mm x 6.5 mm
//
// The can is centered on the origin, with the two flat faces on the X sides.
// The output shaft extends along +Z from the front face, which carries a
// small bearing boss.

module dc_motor_130_model(
    body_diameter = 20,
    flat_width = 15.1,
    body_length = 25,
    front_boss_diameter = 6,
    front_boss_height = 1,
    shaft_diameter = 2,
    shaft_length = 6.5
){
    $fn = 48;

    half_body_length = body_length / 2;

    union(){
        // Flattened cylindrical can: intersecting the round can with a slab
        // of `flat_width` thickness produces the two flat side faces.
        intersection(){
            cylinder(d=body_diameter, h=body_length, center=true);
            cube([flat_width, body_diameter+1, body_length+1], center=true);
        }

        // Front bearing boss.
        translate([0, 0, half_body_length])
        cylinder(d=front_boss_diameter, h=front_boss_height);

        // Output shaft.
        translate([0, 0, half_body_length + front_boss_height])
        cylinder(d=shaft_diameter, h=shaft_length);
    }
}
