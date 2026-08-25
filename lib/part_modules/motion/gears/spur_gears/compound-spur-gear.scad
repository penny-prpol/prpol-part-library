// In Revision



module compound_spur_gear(
    size1 = 5,
    size2 = 1,
    thickness1 = 10,
    thickness2 = 10,
    axis_bore_diameter = global_default_hole_diameter,
    chamfer_depth = 1.5,
    nut_clearance = 0.1,
    nut_width = global_default_nut_width,
    nut_thickness = 2.25,
    nut_offset = 3.5,
    lock_bore_diameter = global_default_hole_diameter,
    hub_diameter = 17,
    rim_thickness = 8,
    spoke_count = 4,
    spoke_width = 7
){
    // Main gear from plain_spur_gear (spokes, chamfers, nut pocket, grid
    // holes), then the small gear stacked on top.
    union(){
        translate([0,0,thickness1])
        rotate(180,[1,0,0])
        plain_spur_gear(
            size = size1,
            thickness = thickness1,
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
            do_nut_pocket = true
        );
        translate([0, 0, thickness1])
        plain_spur_gear(
            size = size2,
            thickness = thickness2,
            axis_bore_diameter = axis_bore_diameter,
            chamfer_depth = 0,
            nut_clearance = nut_clearance,
            nut_width = nut_width,
            nut_thickness = nut_thickness,
            nut_offset = nut_offset,
            lock_bore_diameter = lock_bore_diameter,
            hub_diameter = hub_diameter,
            rim_thickness = rim_thickness,
            spoke_count = spoke_count,
            spoke_width = spoke_width,
            do_nut_pocket = false
        );
    }
}



