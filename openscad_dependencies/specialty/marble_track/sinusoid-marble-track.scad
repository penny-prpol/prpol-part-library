// In Revision
module sinusoid_marble_track(
    inner_diameter = 20,
    wall_thickness = 3,
    left_lip_placement_angle = 180,
    right_lip_placement_angle = 0

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
        for (a = [right_stop_angle : -5 : left_stop_angle - 360 ])
        [outer_radius * cos(a),
        outer_radius * sin(a) + outer_radius]
    ];

    left_round_lip = [
        for (a = [left_stop_angle - 10 : -10 : left_stop_angle - 180 + 10]) //start and stop angle
        [left_lip_center[0] + lip_radius * cos(a), //x coordinate of each point
        left_lip_center[1] + lip_radius * sin(a)] //y coordinate of each point
    ];

    inner_arc = [
        for (a = [left_stop_angle : 5 : right_stop_angle + 360 ])
        [inner_radius * cos(a),
        inner_radius * sin(a) + outer_radius]
    ];

    right_round_lip = [
        for (a = [right_stop_angle + 180 - 10 : -10 : right_stop_angle + 10 ])
        [right_lip_center[0] + lip_radius * cos(a),
        right_lip_center[1] + lip_radius * sin(a)]
    ];

    //put all the segments together into a single list of points
    polypoints = concat(outer_arc, left_round_lip, inner_arc, right_round_lip);

    inner_circle = [
        for (a = [0 : 5 : 355])
        [inner_radius * cos(a),
        inner_radius * sin(a) + outer_radius]
    ];
    
    //support target trough; used only to generate supports

    support_target_left_stop_angle = left_stop_angle + 30;
    support_target_right_stop_angle = right_stop_angle - 30;

    support_target_left_lip_center = [ // support target left lip center
        midwall_radius * cos(support_target_left_stop_angle), //x coordinate
        midwall_radius * sin(support_target_left_stop_angle) + outer_radius //y coordinate
    ];

    support_target_right_lip_center = [ // support target right lip center
        midwall_radius * cos(support_target_right_stop_angle), //x coordinate
        midwall_radius * sin(support_target_right_stop_angle) + outer_radius //y coordinate
    ];

    //segments of support target trough

    support_target_outer_arc = [
        for (a = [support_target_right_stop_angle : -5 : support_target_left_stop_angle - 360 ])
        [outer_radius * cos(a),
        outer_radius * sin(a) + outer_radius]
    ];

    support_target_left_round_lip = [
        for (a = [support_target_left_stop_angle - 10 : -10 : support_target_left_stop_angle - 180 + 10]) //start and stop angle
        [support_target_left_lip_center[0] + lip_radius * cos(a), //x coordinate of each point
        support_target_left_lip_center[1] + lip_radius * sin(a)] //y coordinate of each point
    ];

    support_target_inner_arc = [
        for (a = [support_target_left_stop_angle : 5 : support_target_right_stop_angle + 360 ])
        [inner_radius * cos(a),
        inner_radius * sin(a) + outer_radius]
    ];

    support_target_right_round_lip = [
        for (a = [support_target_right_stop_angle + 180 - 10 : -10 : support_target_right_stop_angle + 10 ])
        [support_target_right_lip_center[0] + lip_radius * cos(a),
        support_target_right_lip_center[1] + lip_radius * sin(a)]
    ];

    support_target_polypoints = concat(
        support_target_outer_arc,
        support_target_left_round_lip,
        support_target_inner_arc,
        support_target_right_round_lip
    );
   
    //generate the thing
    //trail = [[0,0,0],[50,0,0]];
    trail = [
        for (i = [0 : 1 : 100])
        [i , 0 , 0]
    ];

    spinjitsu = [
        for (i = [0 : 1 : 100])
        180 + i
    ];

    fly_right = [
        for (i = [0:720])
        140 + i * 0.1876
    ];

    critter_trail = [
        for (i = [0:720])
        [30 * cos(i), 30 * sin(i), i / 10]
    ];

    straight_path = [[50,0,0],[50,300,25]];
    sinusoid_path = [
        for(i = [0:300])
        [60 - 10 * cos(4 * (i / 300) * 360),
        i,
        25 * (i / 300)]
    ];

   union(){
        //first support arm
        difference(){
            hull(){
                translate([10,100 - 7.5 - 4, 0])
                cube([4,4,15]);

                intersection(){
                    translate([0,100 - 7.5 - 4, 0])
                    cube([100, 4 , 100]);

                    path_extrude(exPath = sinusoid_path, exShape = support_target_polypoints, exRots = [180]);
                }

            }
            path_extrude(exPath = sinusoid_path, exShape = inner_circle, exRots = [180]);
        }

        //second support arm
        difference(){
            hull(){
                translate([10,100 + 7.5, 0])
                cube([4,4,15]);

                intersection(){
                    translate([0,100 + 7.5, 0])
                    cube([100, 4 , 100]);

                    path_extrude(exPath = sinusoid_path, exShape = support_target_polypoints, exRots = [180]);
                }

            }
            path_extrude(exPath = sinusoid_path, exShape = inner_circle, exRots = [180]);
        }

        //third support arm
        difference(){
            hull(){
                translate([10,200 - 7.5 - 4, 0])
                cube([4,4,15]);

                intersection(){
                    translate([0,200 - 7.5 - 4, 0])
                    cube([100, 4 , 100]);

                    path_extrude(exPath = sinusoid_path, exShape = support_target_polypoints, exRots = [180]);
                }

            }
            path_extrude(exPath = sinusoid_path, exShape = inner_circle, exRots = [180]);
        }

        //fourth support arm
        difference(){
            hull(){
                translate([10,200 + 7.5, 0])
                cube([4,4,15]);

                intersection(){
                    translate([0,200 + 7.5, 0])
                    cube([100, 4 , 100]);

                    path_extrude(exPath = sinusoid_path, exShape = support_target_polypoints, exRots = [180]);
                }

            }
            path_extrude(exPath = sinusoid_path, exShape = inner_circle, exRots = [180]);
        }

        //first attachment plate
        difference(){
            translate([10,100-7.5,-5])
            cube([4, 15, 75 + 5 + 5]);
            for(i = [0 : 25 : 75]){
                translate([-1, 100, i])
                rotate(90, [0,1,0])
                cylinder(d = 3.3,h=50,$fn = 20);
            }
        }
        
        //second attachment plate
        difference(){
            translate([10,200-7.5,-5])
            cube([4, 15, 75 + 5 + 5]);
            for(i = [0 : 25 : 75]){
                translate([-1, 200, i])
                rotate(90, [0,1,0])
                cylinder(d = 3.3,h=50,$fn = 20);
            }
        }
        
        //the marble track
        path_extrude(exPath = sinusoid_path, exShape = polypoints, exRots = [180]);
   }

    
}

