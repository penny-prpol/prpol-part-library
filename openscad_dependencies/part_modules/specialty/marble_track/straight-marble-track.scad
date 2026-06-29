module straight_marble_track(
    inner_diameter = 18,
    wall_thickness = 2,
    left_lip_placement_angle = 180,
    right_lip_placement_angle = 0,
    mirrored = false
){
    inner_radius = inner_diameter / 2;
    outer_diameter = inner_diameter + (2 * wall_thickness);
    outer_radius = outer_diameter / 2;
    midwall_radius = outer_radius - wall_thickness / 2;
    lip_radius = wall_thickness / 2;

    correction_angle = 10;
    left_stop_angle = left_lip_placement_angle + correction_angle;
    right_stop_angle = right_lip_placement_angle - correction_angle;

    left_lip_center = [
        midwall_radius * cos(left_stop_angle),
        midwall_radius * sin(left_stop_angle) + outer_radius
    ];

    right_lip_center = [
        midwall_radius * cos(right_stop_angle),
        midwall_radius * sin(right_stop_angle) + outer_radius
    ];

    outer_arc = [
        for (a = [right_stop_angle : -5 : left_stop_angle - 360])
        [outer_radius * cos(a), outer_radius * sin(a) + outer_radius]
    ];

    left_round_lip = [
        for (a = [left_stop_angle - 10 : -10 : left_stop_angle - 180 + 10])
        [left_lip_center[0] + lip_radius * cos(a),
         left_lip_center[1] + lip_radius * sin(a)]
    ];

    inner_arc = [
        for (a = [left_stop_angle : 5 : right_stop_angle + 360])
        [inner_radius * cos(a), inner_radius * sin(a) + outer_radius]
    ];

    right_round_lip = [
        for (a = [right_stop_angle + 180 - 10 : -10 : right_stop_angle + 10])
        [right_lip_center[0] + lip_radius * cos(a),
         right_lip_center[1] + lip_radius * sin(a)]
    ];

    polypoints = concat(outer_arc, left_round_lip, inner_arc, right_round_lip);

    // Straight path: [12, 0, 5] → [12, 200, 15] (slope 5/100 over 200mm Y-span, gross Z offset of 5)
    steps = 10;
    track_path = [
        for (i = [0 : steps])
        [12, i / steps * 200, 5 + i / steps * 10]
    ];

    rotation_plan = [for (i = [0 : steps]) 180];

    scale([1, mirrored ? -1 : 1, 1])
    union(){

        // the marble track
        path_extrude(exPath = track_path, exShape = polypoints, exRots = rotation_plan);

        // lower end connection (standard for all lower ends)
        difference(){
            union(){
                rotate(90,[0,1,0])
                cylinder(d=6,h=12,$fn=20);
                difference(){
                    hull(){
                        cube([12,3,3]);

                        translate([0,0,8.5])
                        rotate(45,[0,1,0])
                        cube([13,3,3]);

                        translate([9,0,3])
                        cube([3,3,3]);
                    }
                }
            }
            rotate(90,[0,1,0])
            cylinder(d=3.3,h=30,$fn=20,center=true);
        }

        // upper end connection (standard for all upper ends)
        translate([0, 200, 10])
        difference(){
            union(){
                translate([12,0,0])
                rotate(90,[0,1,0])
                cylinder(d=6,h=4,$fn=20);

                hull(){
                    translate([12,-3,0])
                    cube([4,3,6]);
                }
            }
            rotate(90,[0,1,0])
            cylinder(d=3.3,h=40,$fn=20,center=true);
        }

    }  // end union

}
