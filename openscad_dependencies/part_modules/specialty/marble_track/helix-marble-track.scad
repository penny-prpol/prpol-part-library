// In Development
// In Revision
module helix_marble_track(
    inner_diameter = 18,
    wall_thickness = 2,
    left_lip_placement_angle = 180,
    right_lip_placement_angle = 0,
    num_turns = 4,
    cup_wall = 4,
    cup_height = 8,
    cup_floor = 4,
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
        midwall_radius * cos(left_stop_angle), //x coordinate
        midwall_radius * sin(left_stop_angle) + outer_radius //y coordinate
    ];

    right_lip_center = [
        midwall_radius * cos(right_stop_angle), //x coordinate
        midwall_radius * sin(right_stop_angle) + outer_radius //y coordinate
    ];

    //segments of marble trough

    outer_arc = [
        for (a = [right_stop_angle : -5 : left_stop_angle - 360])
        [outer_radius * cos(a), outer_radius * sin(a) + outer_radius]
    ];

    left_round_lip = [
        for (a = [left_stop_angle - 10 : -10 : left_stop_angle - 180 + 10]) //start and stop angle
        [left_lip_center[0] + lip_radius * cos(a), //x coordinate of each point
         left_lip_center[1] + lip_radius * sin(a)]  //y coordinate of each point
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

    //put all the segments together into a single list of points
    polypoints = concat(outer_arc, left_round_lip, inner_arc, right_round_lip);

    testriangle = [[-2,0],[0,2],[2,0]];

    straight_steps = 20;  // points per straight transitional section; controls banking ramp smoothness

    starting_path = [
        for (j = [0 : straight_steps])
        [12, j / straight_steps * 100, 5 + j / straight_steps * 5]
    ];

    ending_path = [
        for (j = [0 : straight_steps])
        [12, 100 + j / straight_steps * 100, 100 + j / straight_steps * 5]
    ];

    // Helix connecting [12,100,10] to [12,100,100].
    // Center is at (12 + helix_radius, 100) so the spiral curves rightward (+x) first.
    // Radius derived from slope-continuity condition at the endpoints:
    //   tangent must be proportional to [0, 100, 5] (slope = 5/100 = 1/20)
    //   => 90 / (2*PI*N*r) = 1/20  =>  r = 900 / (PI * N)
    helix_steps = 500;  // number of segments in the helix; increase for smoother output
    helix_radius = 900 / (PI * num_turns);  // ≈ 71.6 mm for N=4
    helix_center_x = 12 + helix_radius;
    pitch = 90 / num_turns;  // z-rise per full turn (total helix z-rise = 90)
    p_rad = pitch / (2 * PI);  // z-rise per radian of t; needed for torsion calculation
    // omega = degrees of torsion-induced frame rotation per degree of t
    // derived from: tau (radians/arc-length) * arc-length/degree * (180/pi)
    omega = p_rad / sqrt(helix_radius * helix_radius + p_rad * p_rad);

    helix_path = [
        for (i = [1 : helix_steps - 1])  // exclude endpoints; starting_path and ending_path supply them
        let (t = i / helix_steps * 360 * num_turns)  // t in degrees, 0..360*N
        [
            helix_center_x - helix_radius * cos(t),  // x: starts at 12, curves right
            100 + helix_radius * sin(t),              // y: starts at 100, loops forward
            10 + (i / helix_steps) * 90               // z: linear rise from 10 to 100
        ]
    ];

    full_path = concat(starting_path, helix_path, ending_path);

    // rotation at end of helix after full torsion correction; starting point for ending ramp
    helix_end_rot = 200 - 360 * num_turns * omega;

    rotation_plan = concat(
        // starting straight: ramp from 180 (endpoint) to 200 (helix entry)
        [for (j = [0 : straight_steps]) 180 + (j / straight_steps) * 20],
        // helix: baseline 200, counter-rotated by accumulated torsion
        [for (i = [1 : helix_steps - 1])
            let (t = i / helix_steps * 360 * num_turns)
            200 - t * omega],
        // ending straight: ramp from helix_end_rot back to flat (un-bank by 20 degrees)
        [for (j = [0 : straight_steps])
            helix_end_rot + (j / straight_steps) * (-20)]
    );

    // cup geometry
    cup_outer_r = 5 + cup_wall;          // 9
    cup_inner_r = 5.3;                    // clearance fit over column r=5
    cup_bottom_z = -10 - cup_floor;      // floor top at z=-10 (column bottom)
    wall_mid_r = 5 + cup_wall / 2;       // 7; hull arm anchor sits within cup wall

    // direction angles from cup center toward each anchor pair
    left_angle  = atan2((50 + 10 - 2) - 100, 2 - helix_center_x);   // toward y=58
    right_angle = atan2((150 - 10 + 2) - 100, 2 - helix_center_x);  // toward y=142

    scale([1, mirrored ? -1 : 1, 1])
    union(){

        // ── piece 1: track body ───────────────────────────────────────────────

        //the marble track
        path_extrude(exPath = full_path, exShape = polypoints, exRots = rotation_plan);

        //end connection interfaces

        //lower end connection (standard for all lower ends)
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

        //upper end connection (standard for all upper ends)
        translate([0, 200, 100])
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

        // central support column at helix center, full height of helix section
        translate([helix_center_x, 100, -10])
        cylinder(h = 100, r = 5, $fn = 24);

        //radial support arms
        for (i = [0 : num_turns * 3 - 1])
        let (angle = i * 120) {
            hull(){
                translate([helix_center_x, 100, -5 + i * pitch / 3])
                cylinder(d=4, h=10, $fn=20);

                translate([
                    helix_center_x + (helix_radius - 10) * sin(angle),
                    100 + (helix_radius - 10) * cos(angle),
                    -5 + (i + 3) * pitch / 3 - 2
                ])
                rotate(120 * i, [0,0,-1])
                rotate(40, [1,0,0])
                cylinder(d=4, h=6, $fn=20);
            }
        }

        // ── piece 2: mount (translated -30 in Z to make it clear they are separate pieces.) ────────────────

        translate([0, 0, -30])
        union(){

            // cup + upper arms: the cavity is subtracted last so arm hulls can't encroach into the pocket
            difference(){
                union(){
                    // cup solid base
                    translate([helix_center_x, 100, cup_bottom_z])
                    cylinder(r = cup_outer_r, h = cup_height, $fn = 64);

                    // upper-left block to cup
                    hull(){
                        translate([
                            helix_center_x + wall_mid_r * cos(left_angle),
                            100 + wall_mid_r * sin(left_angle),
                            cup_bottom_z
                        ])
                        cylinder(d=4, h=cup_height, $fn=20);

                        translate([2, 50 + 10 - 2, -10])
                        cylinder(d=4, h=17, $fn=30);
                    }

                    // upper-right block to cup
                    hull(){
                        translate([
                            helix_center_x + wall_mid_r * cos(right_angle),
                            100 + wall_mid_r * sin(right_angle),
                            cup_bottom_z
                        ])
                        cylinder(d=4, h=cup_height, $fn=20);

                        translate([2, 150 - 10 + 2, -10])
                        cylinder(d=4, h=20, $fn=30);
                    }
                }
                // inner cavity carved out after all solids are merged
                translate([helix_center_x, 100, cup_bottom_z + cup_floor])
                cylinder(r = cup_inner_r, h = cup_height - cup_floor + 1, $fn = 64);
            }

            // lower-left block to cup
            hull(){
                translate([helix_center_x, 100, cup_bottom_z + cup_floor / 2])
                rotate([0, 90, 0])
                cylinder(d = 3, h = 2 * (cup_outer_r - 1), center = true, $fn = 20);

                translate([2, 50 + 10 - 2, -110])
                cylinder(d=4, h=20, $fn=30);
            }

            // lower-right block to cup
            hull(){
                translate([helix_center_x, 100, cup_bottom_z + cup_floor / 2])
                rotate([0, 90, 0])
                cylinder(d = 3, h = 2 * (cup_outer_r - 1), center = true, $fn = 20);

                translate([2, 150 - 10 + 2, -110])
                cylinder(d=4, h=20, $fn=30);
            }

            // the anchor blocks
            translate([0, 50, 0])
            difference(){
                translate([0, -10, -10])
                cube([4, 20, 20]);

                rotate(90, [0,1,0])
                cylinder(h=15, d=3.3, center=true, $fn=20);
            }

            translate([0, 50, -100])
            difference(){
                translate([0, -10, -10])
                cube([4, 20, 20]);

                rotate(90, [0,1,0])
                cylinder(h=15, d=3.3, center=true, $fn=20);
            }

            translate([0, 150, 0])
            difference(){
                translate([0, -10, -10])
                cube([4, 20, 20]);

                rotate(90, [0,1,0])
                cylinder(h=15, d=3.3, center=true, $fn=20);
            }

            translate([0, 150, -100])
            difference(){
                translate([0, -10, -10])
                cube([4, 20, 20]);

                rotate(90, [0,1,0])
                cylinder(h=15, d=3.3, center=true, $fn=20);
            }

        }  // end piece 2 union

    }  // end union

}

