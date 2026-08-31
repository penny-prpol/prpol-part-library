// Catapult scoop — a torus-section scoop with a straight tail and a bolted
// attaching block for the robot grid.

module catapult_scoop(
    projectile_diameter = 25,
    extra_margin = 1,
    straight_section_length = 25,
    scoop_extrude_radius = 50,
    bolt_hole_diameter = global_default_hole_diameter
){
    $fn = 50;

    inner_scoop_d = projectile_diameter + extra_margin;
    outer_scoop_d = inner_scoop_d + 8;
    overall_height = outer_scoop_d - 4;

    union(){
        // scoop
        translate([0, 0, overall_height / 2])
        difference(){
            // body torus
            rotate_extrude(convexity = 10){
                translate([scoop_extrude_radius, 0, 0]) circle(d = outer_scoop_d);
            }
            // inner (cutting) cylinder
            cylinder(r = scoop_extrude_radius, h = 100, center = true);
            // inner (cutting) torus
            rotate_extrude(convexity = 10){
                translate([scoop_extrude_radius, 0, 0]) circle(d = inner_scoop_d);
            }
            // top and bottom surface cuts (to make it printable)
            translate([-100, -100, overall_height / 2]) cube([200, 200, 200]);
            translate([-100, -100, -200 - overall_height / 2]) cube([200, 200, 200]);
            // pie slicing cuts
            translate([-200, -100, -100]) cube([200, 200, 200]);
            translate([0, -200, -100]) cube([200, 200, 200]);
            rotate(45) translate([0, 0, -100]) cube([200, 200, 200]);
        }

        // straight end-section
        difference(){
            rotate(45)
            translate([scoop_extrude_radius, 0, overall_height / 2])
            rotate(90, [-1, 0, 0])
            difference(){
                translate([0, 0, -0.5])
                cylinder(d = outer_scoop_d, h = straight_section_length + 0.5);
                translate([0, 0, -2])
                cylinder(d = inner_scoop_d, h = straight_section_length + 4);
                translate([-200, -100, -100]) cube([200, 200, 200]);
            }
            translate([-100, -100, overall_height]) cube([200, 200, 200]);
            translate([-100, -100, -200]) cube([200, 200, 200]);
        }

        // attaching block
        translate([scoop_extrude_radius, -10, 0])
        difference(){
            cube([20, 10, overall_height]);
            translate([5, -15, overall_height / 2 - 5])
                rotate(90, [-1, 0, 0])
                cylinder(h = 100, d = bolt_hole_diameter);
            translate([5, -15, overall_height / 2 + 5])
                rotate(90, [-1, 0, 0])
                cylinder(h = 100, d = bolt_hole_diameter);
        }
    }
}
