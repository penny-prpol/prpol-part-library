//rectangle truss panel
//used to cover a rectangle formed by two hyp struts and two leg struts
//in a truss assembly.

module rectangle_truss_panel(
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

    //calculating panel dimensions and positioning for gapless form
    gapless_leg_dim = hub_spacing; 
    gapless_hyp_dim = hub_spacing * sqrt(2);
    half_trileg = hub_octagon_triangle_leg / 2;

    
    
    if(gaps == false){
        
        difference(){
            translate([half_side_length + half_trileg, -half_side_length - half_trileg, 0])
            rotate(-45)
            translate([-thickness, 0 , 0])
            chamferCube([thickness, gapless_hyp_dim, gapless_leg_dim], chamfer_depth = chamfer_depth);

            // cutting hub proxies, cuting render-improving blocks
            translate(chamfer_cube_to_center_vector)
            chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);
            rotate(-45)
            cube([50,hub_octagon_side_length, hub_octagon_side_length], center=true);

            translate([0,0,hub_spacing]){
                translate(chamfer_cube_to_center_vector)
                chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

                rotate(-45)
                cube([50,hub_octagon_side_length, hub_octagon_side_length], center=true);
            }
            

            translate([hub_spacing,hub_spacing,hub_spacing]){
                translate(chamfer_cube_to_center_vector)
                chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

                rotate(-45)
                cube([50,hub_octagon_side_length, hub_octagon_side_length], center=true);
            }
            

            translate([hub_spacing,hub_spacing,0]){
                translate(chamfer_cube_to_center_vector)
                chamferCube(dimensions= chamfer_cube_dims, chamfer_depth=hub_octagon_triangle_leg);

                rotate(-45)
                cube([50,hub_octagon_side_length, hub_octagon_side_length], center=true);
            }

            // === corner chamfering pyramids ===
            // Outward normal of the rectangular panel is n = [1/√2, -1/√2, 0].
            // Each pyramid is rotated so its base is parallel to the panel face
            // and its apex points inward (along -n).
            {
                pyr_offset = 10 + chamfer_depth;
                pyr_base   = hub_octagon_side_length + 6 * chamfer_depth;

                // Corner A  (0, 0, 0)
                translate([0, 0, 0])
                rotate(a=45, v=[1, -1, 0])   // twist around pyramid central axis (= outward normal n)
                rotate(a=90, v=[1,  1, 0])   // orient central axis Z → n
                translate([0, 0, pyr_offset])
                chamfering_pyramid(base = pyr_base);

                // Corner B  (0, 0, hub_spacing)
                translate([0, 0, hub_spacing])
                rotate(a=45, v=[1, -1, 0])
                rotate(a=90, v=[1,  1, 0])
                translate([0, 0, pyr_offset])
                chamfering_pyramid(base = pyr_base);

                // Corner C  (hub_spacing, hub_spacing, hub_spacing)
                translate([hub_spacing, hub_spacing, hub_spacing])
                rotate(a=45, v=[1, -1, 0])
                rotate(a=90, v=[1,  1, 0])
                translate([0, 0, pyr_offset])
                chamfering_pyramid(base = pyr_base);

                // Corner D  (hub_spacing, hub_spacing, 0)
                translate([hub_spacing, hub_spacing, 0])
                rotate(a=45, v=[1, -1, 0])
                rotate(a=90, v=[1,  1, 0])
                translate([0, 0, pyr_offset])
                chamfering_pyramid(base = pyr_base);
            }

        }
    }
}