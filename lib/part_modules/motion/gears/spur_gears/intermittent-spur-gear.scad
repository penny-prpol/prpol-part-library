// In Revision


module intermittent_spur_gear(
    size = 5,
    missing_teeth = 7,
    thickness = 10,
    axis_bore_diameter = global_default_hole_diameter,
    chamfer_depth = 2,
    nut_clearance = 0.1,
    nut_width = global_default_nut_width,
    nut_thickness = 2.25,
    nut_offset = 3.5,
    lock_bore_diameter = global_default_hole_diameter,
    lock_screw_cap_diameter = 5.6,
    hub_diameter = 17,
    rim_thickness = 8,
    spoke_count = 4,
    spoke_width = 7,
    do_nut_pocket = true
){
    pitch_diameter = size*10;
    cutout_angle = missing_teeth * 360 / (size*10);
    teeth_cutter_points = [[0,0], for(a = [0:1:cutout_angle]) [size * 20 * cos(a), size * 20 * sin(a)] ];

    difference(){
        // Full plain gear (spokes, chamfers, nut pocket, grid holes).
        plain_spur_gear(
            size = size,
            thickness = thickness,
            axis_bore_diameter = axis_bore_diameter,
            chamfer_depth = chamfer_depth,
            nut_clearance = nut_clearance,
            nut_width = nut_width,
            nut_thickness = nut_thickness,
            nut_offset = nut_offset,
            lock_bore_diameter = lock_bore_diameter,
            hub_diameter = hub_diameter,
            rim_thickness = rim_thickness,
            spoke_count = spoke_count,
            spoke_width = spoke_width,
            do_nut_pocket = do_nut_pocket
        );

        //missing teeth cutout
        rotate(360/(size*10)/2){
            difference(){
                linear_extrude(height=100, center=true){
                    polygon(points=teeth_cutter_points);
                }
                cylinder(h=200, d=size*10 - 2.28, center=true);
            }
        }
    }
}



