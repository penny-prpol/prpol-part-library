
//board width = 44
//board length = 44

module L298N_quad_elegoo_transition(
    plate_thickness = 2.5,
    plate_length = 11,
    plate_width = 5,
    grid_hole_diameter = 3.3,
    box_length = 44,
    box_width = 44
){
    difference(){
        chamferCube([plate_length * 10,plate_width * 10,plate_thickness], chamfer_depth = 0.5);

        //grid mount holes
        for(i = [0:4]){
            translate([5,5 + 10*i,0])
            cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);
        }

        for(i = [0:4]){
            translate([plate_length * 10 - 5,5 + 10*i,0])
            cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);
        }

        //PCB mount holes
        //clockwise from bottom left
        translate([
            plate_length * 10 / 2 - box_length / 2 + 3.5,
            plate_width * 10 / 2 - box_width / 2 + 3,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 2.6,
            plate_width * 10 / 2 - box_width / 2  + 39.7,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 40,
            plate_width * 10 / 2 - box_width / 2 + 40.3,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 40,
            plate_width * 10 / 2 - box_width / 2 + 3,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);
    }
    
}