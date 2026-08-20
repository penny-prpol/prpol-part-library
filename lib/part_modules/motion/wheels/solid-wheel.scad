// In Revision

module solid_wheel(
    size = 7,
    thickness = 10,
    rim_radius = 8,
    axis_bore_diameter = 3.2,
    nut_clearance = 0.1,
    nut_width = 5.5,
    nut_thickness = 2.25,
    hub_diameter = 14,
    spoke_count = 5,
    spoke_width = 4
){
    //DERIVED VALUES (NO TOUCHY)
    torus_diameter = size * 10;
    inner_diameter = torus_diameter - 10;
    increment_angle = 360 / spoke_count;
    nut_circumscribed_diameter = nut_width / cos(30);

    $fn = 100;

    difference(){
        union(){
            // Outer torus rim
            translate([0, 0, thickness / 2])
            difference(){
                intersection(){
                    rotate_extrude(convexity = 10)
                    translate([torus_diameter / 2 - rim_radius, 0, 0])
                    circle(r = rim_radius);
                    cylinder(d = torus_diameter, h = thickness, center = true);
                }
                cylinder(d = inner_diameter, h = 50, center = true);
            }

            // Spokes
            for(i = [0 : spoke_count - 1]){
                rotate(i * increment_angle, [0, 0, 1])
                translate([0, -spoke_width / 2, 0])
                cube([inner_diameter / 2 + 1, spoke_width, thickness]);
            }

            // Central hub
            cylinder(d = hub_diameter, h = thickness);
        }

        // Axis bore
        cylinder(d = axis_bore_diameter, h = 100, center = true);

        // Lock screw hole and nut pocket
        rotate(360 / (2 * spoke_count), [0, 0, 1]){
            translate([0, 0, thickness / 2])
            rotate(90, [0, 1, 0])
            cylinder(h = size * 10, d = 3.2);

            translate([2.2, -(nut_width + nut_clearance) / 2,
                       thickness - (thickness / 2 + nut_circumscribed_diameter / 2)]){
                cube([nut_thickness + nut_clearance,
                      nut_width + nut_clearance,
                      thickness / 2 + nut_circumscribed_diameter / 2]);
            }
        }
    }

}
