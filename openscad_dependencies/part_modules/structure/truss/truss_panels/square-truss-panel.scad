// Generate a 3D grid ("cloud") of hub proxy chamfer cubes arranged in a
// repeating cubic pattern matching the truss hub spacing.  Each proxy is
// a chamfered cube with the same dimensions and chamfer depth as a real hub,
// suitable for use as a cutting body or for visualization.
//
//   grid_size   — [nx, ny, nz] number of hubs along each axis (default 5×5×5)
//   hub_spacing — center-to-center distance between hubs in mm (default 100)
//   hub_width   — side length of each hub cube in mm (default 20)

module hub_proxy_cloud(
    grid_size   = [5, 5, 5],
    hub_spacing = 100,
    hub_width   = 20
) {
    hub_octagon_side_length = hub_width * tan(22.5);
    hub_octagon_triangle_leg = hub_octagon_side_length / sqrt(2);
    centering_distance = -hub_width / 2;

    for (ix = [0 : grid_size[0] - 1]) {
        for (iy = [0 : grid_size[1] - 1]) {
            for (iz = [0 : grid_size[2] - 1]) {
                translate([
                    ix * hub_spacing + centering_distance,
                    iy * hub_spacing + centering_distance,
                    iz * hub_spacing + centering_distance
                ])
                chamferCube(
                    dimensions    = [hub_width, hub_width, hub_width],
                    chamfer_depth = hub_octagon_triangle_leg
                );
            }
        }
    }
}

module square_truss_panel(
    face = "Z0",
    mount_holes = false,
    gaps = false,
    hub_width = 20,
    hub_spacing = 100,
    thickness = 4,
    chamfer_depth = 0.8
){  
    //hub proxy cutting body calculations
    chamfer_cube_dims = [hub_width, hub_width, hub_width];
    centering_distance = -hub_width / 2;
    chamfer_cube_to_center_vector = [centering_distance, centering_distance, centering_distance];

    //calculate panel dimensions
    hub_octagon_side_length = hub_width * tan(22.5);
    panel_width = hub_spacing - hub_octagon_side_length;

    hub_octagon_triangle_leg = hub_octagon_side_length / sqrt(2);
    interface_thickness = hub_octagon_triangle_leg;

    //calculate gap form positioning
    offsetv = hub_octagon_side_length / 2;
    positioning_vector = [offsetv, offsetv, offsetv];

    // Gapless form: outside face is anchored flush with hub exterior.
    // Outside face Z = offsetv + interface_thickness (hub outer boundary).
    // Inside face Z = outside_face_Z - thickness.
    gapless_offset_z = offsetv + interface_thickness - thickness;

    
   

    module panel_geometry() {
        rotate(180,[1,1,0])
        difference(){

            if(gaps == true){
                translate(positioning_vector)
                chamferCube(dimensions = [panel_width, panel_width, thickness], chamfer_depth = chamfer_depth );
            }
            else{
                translate([0,0,gapless_offset_z])
                chamferCube(dimensions = [hub_spacing, hub_spacing, thickness], chamfer_depth = chamfer_depth);
            }

            // cutting hub proxies
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            translate([hub_spacing,0,0])
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            translate([hub_spacing,hub_spacing,0])
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            translate([0,hub_spacing,0])
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            if(gaps == false){
            // cutting cubes (purely for preview cleanup)

            cube([hub_octagon_side_length, hub_octagon_side_length, 50], center = true);

            translate([hub_spacing,0,0])
            cube([hub_octagon_side_length, hub_octagon_side_length, 50], center = true);

            translate([hub_spacing,hub_spacing,0])
            cube([hub_octagon_side_length, hub_octagon_side_length, 50], center = true);

            translate([0,hub_spacing,0])
            cube([hub_octagon_side_length, hub_octagon_side_length, 50], center = true);

            // corner chamfering pyramids - one per corner, no rotation needed only translation

             translate([0,0,10 + chamfer_depth])
            chamfering_pyramid(base = hub_octagon_side_length + 6 * chamfer_depth);

            translate([hub_spacing,0,10 + chamfer_depth])
            chamfering_pyramid(base = hub_octagon_side_length + 6 * chamfer_depth);

            translate([hub_spacing,hub_spacing,10 + chamfer_depth])
            chamfering_pyramid(base = hub_octagon_side_length + 6 * chamfer_depth);

            translate([0,hub_spacing,10 + chamfer_depth])
            chamfering_pyramid(base = hub_octagon_side_length + 6 * chamfer_depth);

            //chamfering blocks used for chamfering sharp edges formed by the hub proxy difference
            //chamfering block pair at origin
            translate([hub_octagon_side_length / 2, 0, 10])
            rotate(45,[0,-1,0])
            rotate(45, [0,0,1])
            cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);

            rotate(90,[0,0,1])
            translate([hub_octagon_side_length / 2, 0, 10])
            rotate(45,[0,-1,0])
            rotate(45, [0,0,1])
            cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);

            //chamfering block pair at [1,0]
            translate([hub_spacing,0,0])
            rotate(90){
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);

                rotate(90,[0,0,1])
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);
            }

            //chamfering block pair at [1,1]
            translate([hub_spacing,hub_spacing,0])
            rotate(180){
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);

                rotate(90,[0,0,1])
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);
            }

            //chamfering block pair at [0,1]
            translate([0,hub_spacing,0])
            rotate(270){
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);

                rotate(90,[0,0,1])
                translate([hub_octagon_side_length / 2, 0, 10])
                rotate(45,[0,-1,0])
                rotate(45, [0,0,1])
                cube([chamfer_depth * 2, chamfer_depth * 2, 50], center = true);
            }
            }
        }
    }

    //the two faces parallel to the XY plane
    if(face == "Z0" || face == "z0"){
        panel_geometry();
    }
    else if(face == "Z1" || face == "z1"){
        translate([0,0,hub_spacing])
        rotate(180,[1,1,0])
        panel_geometry();
    }

    //the two faces parallel to the YZ plane
    else if(face == "X0" || face == "x0"){
        translate([0,0,hub_spacing])
        rotate(90,[0,1,0])
        panel_geometry();
    }
    else if(face == "X1" || face == "x1"){
        translate([hub_spacing,0,0])
        rotate(-90,[0,1,0])
        panel_geometry();
    }

    //the two faces parallel to the XZ plane
    else if(face == "Y0" || face == "y0"){
        translate([0,0,hub_spacing])
        rotate(-90, [1,0,0])
        panel_geometry();
    }

    else if(face == "Y1" || face == "y1"){
        translate([0,hub_spacing,0])
        rotate(90, [1,0,0])
        panel_geometry();
    }

}

// Temporary test: all six faces
module test_all_faces() {
    square_truss_panel(face = "Z0");
    square_truss_panel(face = "Z1");
    square_truss_panel(face = "X0");
    square_truss_panel(face = "X1");
    square_truss_panel(face = "Y0");
    square_truss_panel(face = "Y1");
}


