// triangle truss panel
// used in conjunction with rectangle truss panels.
// covers the triangular shape made by a hyp strut and two leg struts.
// Used only where the hyp strut is an edge of the truss.
module triangle_truss_panel(
    gaps = false,
    hub_width = 20,
    hub_spacing = 100,
    thickness = 4,
    chamfer_depth = 0.8
){  
    half_hub_width = hub_width / 2;
    //hub proxy cutting body calculations
    chamfer_cube_dims = [hub_width, hub_width, hub_width];
    centering_distance = -half_hub_width;
    chamfer_cube_to_center_vector = [centering_distance, centering_distance, centering_distance];

    //intermediate calculations
    hub_octagon_side_length = hub_width * tan(22.5);
    half_side_length = hub_octagon_side_length / 2;

    hub_octagon_triangle_leg = hub_octagon_side_length / sqrt(2);
    interface_thickness = hub_octagon_triangle_leg;

    //imagine an X drawn on one of the square faces of the hub.
    //x_leg_length is half the length of one of these diagonals.

    x_leg_length = hub_octagon_side_length * sqrt(2) / 2;

    scale_factor = (half_hub_width - thickness) / half_hub_width;

    //hyp spacing
    hyp_spacing = hub_spacing * sqrt(2);

    poly_points = [
        [0,half_hub_width],
        [x_leg_length, half_hub_width],
        [half_hub_width, half_side_length],
        [half_hub_width,0],
        [half_hub_width - thickness, 0],
        //the two scaley points
        [half_hub_width - thickness, half_side_length * scale_factor],
        [x_leg_length * scale_factor, half_hub_width - thickness],
        //the last point
        [0,half_hub_width - thickness]
    ];


    difference(){
        translate([0,0,hub_spacing])
        rotate(-45,[0,0,1])
        translate([0,hyp_spacing,0])
        rotate(90,[1,0,0])
        linear_extrude(height = hyp_spacing)
        polygon(poly_points);

        //cutting hub proxies
        translate([0,0,hub_spacing])
        translate(chamfer_cube_to_center_vector)
        chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

        translate([hub_spacing,hub_spacing,hub_spacing])
        translate(chamfer_cube_to_center_vector)
        chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

        //cutting render-prettifying blocks
        translate([0,0,hub_spacing])
        translate([0,-hub_octagon_triangle_leg - hub_octagon_side_length,0])
        cube([hub_width,hub_width,hub_width], center = true);

        translate([0,0,hub_spacing])
        translate([-hub_octagon_triangle_leg,0,1])
        cube([hub_width,hub_width,hub_width], center = true);

        translate([hub_spacing,hub_spacing,hub_spacing])
        translate([0,hub_octagon_triangle_leg,1])
        cube([hub_width,hub_width,hub_width], center = true);

        translate([hub_spacing,hub_spacing,hub_spacing])
        translate([hub_octagon_triangle_leg + hub_octagon_side_length,0,0])
        cube([hub_width,hub_width,hub_width], center = true);

        //cutting chamfering blocks

        //block 1
        translate([0,0,hub_spacing])
        translate([half_side_length,0,half_hub_width])
        rotate(45,[0,1,0])
        cube([chamfer_depth * 2 * sqrt(2), hub_width * 2, chamfer_depth * 2 * sqrt(2)], center = true);

        //block 2 - mirror of block 1 across plane x + y = hub_spacing
        //(plane through [hub_spacing,0,hub_spacing], [0,hub_spacing,hub_spacing], [0,hub_spacing,0])
        translate([hub_spacing/2, hub_spacing/2, 0])
        mirror([1, 1, 0])
        translate([-hub_spacing/2, -hub_spacing/2, 0]) {
            translate([0,0,hub_spacing])
            translate([half_side_length,0,half_hub_width])
            rotate(45,[0,1,0])
            cube([chamfer_depth * 2 * sqrt(2), hub_width * 2, chamfer_depth * 2 * sqrt(2)], center = true);
        }

        //block 3
        translate([0,0,hub_spacing])
        translate([5,-hub_octagon_side_length - hub_octagon_triangle_leg + chamfer_depth * sqrt(2),0])
        cube([hub_width,hub_width,hub_width], center = true);

        //block 4 - mirror of block 3 across plane x + y = hub_spacing
        //(plane through [hub_spacing,0,hub_spacing], [0,hub_spacing,hub_spacing], [0,hub_spacing,0])
        translate([hub_spacing/2, hub_spacing/2, 0])
        mirror([1, 1, 0])
        translate([-hub_spacing/2, -hub_spacing/2, 0]) {
            translate([0,0,hub_spacing])
            translate([5,-hub_octagon_side_length - hub_octagon_triangle_leg + chamfer_depth * sqrt(2),0])
            cube([hub_width,hub_width,hub_width], center = true);
        }

        edge_offset = hub_octagon_side_length / 2 + hub_octagon_triangle_leg / 2;
        //block 5 - along the bottom outer edge; complements chamfer on rectangle panel.
        translate([0,0,hub_spacing])
        translate([edge_offset, -edge_offset,0])
        rotate(-45,[0,0,1])
        rotate(45,[0,1,0])
        cube([chamfer_depth * sqrt(2),2 * hub_spacing * sqrt(2), chamfer_depth * sqrt(2)], center = true);

        
    }
    
   
    
    difference(){
        square_truss_panel(face = "Z1");
        rotate(-45, [0,0,1])
        cube([1000,1000,1000]);
    }

    
    
}

