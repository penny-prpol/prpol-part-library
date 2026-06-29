module convex_edge_panel(
    edge = "000001",
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

    //calculate panel dimensions
    hub_octagon_side_length = hub_width * tan(22.5);
    panel_width = hub_spacing - hub_octagon_side_length;
    half_side_length = hub_octagon_side_length / 2;

    hub_octagon_triangle_leg = hub_octagon_side_length / sqrt(2);
    interface_thickness = hub_octagon_triangle_leg;

    //calculate chamfering block height
    chamfering_block_height = half_side_length + chamfer_depth;

   profile_points = [
    [0, half_side_length],
    [0, half_hub_width],
    [half_side_length, half_hub_width],
    [half_hub_width, half_side_length],
    [half_hub_width, 0],
    [half_side_length, 0],
    [half_side_length, half_side_length]
   ];

    module panel_geometry() {
        render()
        difference(){
            rotate(180)
            linear_extrude(height=100)
            polygon(profile_points);

            //cutting hub proxy
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            //cutting hub proxy
            translate([0,0,100])
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

            //chamfering block
            translate([-50,-50,0])
            cube([100,100,chamfering_block_height]);

            //chamfering block
            translate([-50,-50,hub_spacing - chamfering_block_height])
            cube([100,100,chamfering_block_height]);
        }
    }

    //The three edges with the origin as one endpoint:
    if(edge == "000001" || edge == "001000"){
        panel_geometry();
    }

    else if(edge == "000100" || edge == "100000"){
        
        rotate(90,[0,1,0])
        rotate(90, [0,0,1])
        panel_geometry();
    }

    else if(edge == "000010" || edge == "010000"){
        
        rotate(-90,[1,0,0])
        rotate(-90, [0,0,1])
        panel_geometry();
    }

    //The three edges parallel to edge 000001:
    else if(edge == "010011" || edge == "011010"){
        translate([0,hub_spacing,0])
        rotate(-90,[0,0,1])
        panel_geometry();
    }

    else if(edge == "100101" || edge == "101100"){
        translate([hub_spacing,0,0])
        rotate(90,[0,0,1])
        panel_geometry();
    }

    else if(edge == "110111" || edge == "111110"){
        translate([hub_spacing,hub_spacing,0])
        rotate(180,[0,0,1])
        panel_geometry();
    }

    //The three edges parallel to edge 000100:
    else if(edge == "001101" || edge == "101001"){
        translate([0,0,hub_spacing])
        rotate(-90,[1,0,0]) //pre-translate rotation
        rotate(90,[0,1,0])
        rotate(90, [0,0,1])
        panel_geometry();
    }

    else if(edge == "010110" || edge == "110010"){
        translate([0,hub_spacing,0])
        rotate(90,[1,0,0])
        rotate(90,[0,1,0])
        rotate(90, [0,0,1])
        panel_geometry();
    }

    else if(edge == "011111" || edge == "111011"){
        translate([0,hub_spacing,hub_spacing])
        rotate(180,[1,0,0])
        rotate(90,[0,1,0])
        rotate(90, [0,0,1])
        panel_geometry();
    }

    //The three edges parallel to edge 000010:
    else if(edge == "001011" || edge == "011001"){
        translate([0,0,hub_spacing])
        rotate(90,[0,1,0])
        rotate(-90,[1,0,0])
        rotate(-90, [0,0,1])
        panel_geometry();
    }

    else if(edge == "100110" || edge == "110100"){
        translate([hub_spacing,0,0])
        rotate(-90,[0,1,0])
        rotate(-90,[1,0,0])
        rotate(-90, [0,0,1])
        panel_geometry();
    }

    else if(edge == "101111" || edge == "111101"){
        translate([hub_spacing,0,hub_spacing])
        rotate(180,[0,1,0])
        rotate(-90,[1,0,0])
        rotate(-90, [0,0,1])
        panel_geometry();
    }

    //ya done goofed up ya knucklehead
    else{
        cube([67,67,67]);
    }

    
   
}

// Temporary test: all 12 edges
module test_all_edges() {
    // Z-edges
    convex_edge_panel(edge = "000001");
    convex_edge_panel(edge = "010011");
    convex_edge_panel(edge = "100101");
    convex_edge_panel(edge = "110111");
    // X-edges
    convex_edge_panel(edge = "000100");
    convex_edge_panel(edge = "001101");
    convex_edge_panel(edge = "010110");
    convex_edge_panel(edge = "011111");
    // Y-edges
    convex_edge_panel(edge = "000010");
    convex_edge_panel(edge = "001011");
    convex_edge_panel(edge = "100110");
    convex_edge_panel(edge = "101111");
}




