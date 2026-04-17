// In Development
// In Revision
module helix_marble_track(
    inner_diameter = 18,
    wall_thickness = 2,
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

    testriangle = [[-2,0],[0,2],[2,0]];

    starting_segment = [[20,0,0],[20,100,5]];
    ending_segment = [[20,100,95],[20,200,100]];

    // Helix connecting [20,100,5] to [20,100,95].
    // Center is at (20 + helix_radius, 100) so the spiral curves rightward (+x) first.
    // Radius derived from slope-continuity condition at the endpoints:
    //   tangent must be proportional to [0, 100, 5] (slope = 5/100 = 1/20)
    //   => 90 / (2*PI*N*r) = 1/20  =>  r = 900 / (PI * N)
    num_turns = 4;  // integer; controls tightness vs radius
    helix_radius = 900 / (PI * num_turns);  // ≈ 71.6 mm for N=4
    helix_center_x = 20 + helix_radius;
    pitch = 90 / num_turns;  // z-rise per full turn (total helix z-rise = 90)
    p_rad = pitch / (2 * PI);  // z-rise per radian of t; needed for torsion calculation
    // omega = degrees of torsion-induced frame rotation per degree of t
    // derived from: tau (radians/arc-length) * arc-length/degree * (180/pi)
    omega = p_rad / sqrt(helix_radius * helix_radius + p_rad * p_rad);
    helix_path = [
        for (i = [1 : 99])              // exclude endpoints; starting_segment and ending_segment supply them
        let (t = i / 100 * 360 * num_turns)  // t in degrees, 0..360*N
        [
            helix_center_x - helix_radius * cos(t),  // x: starts at 20, curves right
            100 + helix_radius * sin(t),              // y: starts at 100, loops forward
            5 + (i / 100) * 90                       // z: linear rise from 5 to 95
        ]
    ];

    full_path = concat(starting_segment, helix_path, ending_segment);

    rotation_plan = [
        180,
        for (i = [1 : 102])
        let (t = i / 100 * 360 * num_turns)
        180 - t * omega,  // counter-rotate by accumulated torsion
        
    ];
   union(){
       
        
        //the marble track
        path_extrude(exPath = full_path, exShape = polypoints, exRots = rotation_plan);
   }

    
}

