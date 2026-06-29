// In Revision

//The row of grid attachment holes is positioned so that
//the motor axle is aligned with a grid hole position, so 
//that if wanted the motor can turn a gear connected to a
//gear train mounted on the same grid.

module tt_motor_plate_mount(
    plate_thickness = 5
){
    //Two m3 screws are put in the mount holes and calipers are placed
    //outside these two screws, effectively measuring the hole spacing
    //plus half an m3 screw diameter plus half an m3 screw diameter again.
    //This is done for the sake of measurement repeatability.

    m3_spacing_measurement = 20.4;
    m3_screw_diameter = 2.88;

    m3_mount_hole_spacing = m3_spacing_measurement - m3_screw_diameter;

    //35.86
    //An m2 screw is put in the small hole at the opposite side of the motor.
    //The calipers are placed with one side at the outside of the m3 screws and 
    //the other side on the outside of the m2 screw.

    m2_spacing_measurement = 35.86;
    m2_screw_diameter = 1.86;

    m2_mount_hole_spacing = m2_spacing_measurement - (m3_screw_diameter / 2) - (m2_screw_diameter / 2);

    body_width = 22.46;

    body_thickness = 18.44;

    //24.14
    //axle position

    axle_spacing_measurement = 24.14;
    axle_diameter = 5.45;

    axle_spacing = axle_spacing_measurement - (m3_screw_diameter / 2) - (axle_diameter / 2);

    edge_offset = 5;
    
    
    grid_rail_width = 12.5;
    
    m3_hole_diameter = 3.5;
    m2_hole_diameter = 2.5;
    axle_hole_diameter = axle_diameter + 3;
    
    grid_holes_y_position = edge_offset + (m3_mount_hole_spacing / 2) + 20;
    
    mount_plate_dimensions = [
        edge_offset + axle_spacing + 20 + edge_offset,
        grid_holes_y_position + 5 + 10,
        plate_thickness
    ];

    //part generation
    
        difference(){
            chamferCube(mount_plate_dimensions);
            
            //first m3 mount hole
            translate([
                edge_offset,
                edge_offset,
                0
            ])
            cylinder(d=m3_hole_diameter,h=plate_thickness*3,$fn=30);
            
            //second m3 mount hole
            translate([
                edge_offset,
                edge_offset + m3_mount_hole_spacing,
                0
            ])
            cylinder(d=m3_hole_diameter,h=plate_thickness*3,$fn=30);
            
            //axle hole
            translate([
                edge_offset + axle_spacing,
                edge_offset + (m3_mount_hole_spacing / 2),
                0
            ])
            cylinder(d=axle_hole_diameter,h=plate_thickness*3,$fn=30);
            
            //m2 mount hole
            translate([
                edge_offset + m2_mount_hole_spacing,
                edge_offset + (m3_mount_hole_spacing / 2),
                0
            ])
            cylinder(d=m2_hole_diameter,h=plate_thickness*3,$fn=30);
            
            //grid hole pattern
            for(i = [0:4]){
                for(j = [0:1]){
                    translate([
                        edge_offset + axle_spacing - 20 +(i * 10),
                        edge_offset + (m3_mount_hole_spacing / 2) + 20 + (j * 10),
                        0
                    ])
                    cylinder(d=m3_hole_diameter,h=plate_thickness*3, center=true,$fn=30);
                }
            }
        }
    
}
