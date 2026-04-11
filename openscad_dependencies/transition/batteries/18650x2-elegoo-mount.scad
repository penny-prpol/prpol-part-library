// In Revision


module 18650x2_elegoo_mount(
    plate_thickness = 2.5,
    plate_length = 11,
    plate_width = 5,
    grid_hole_diameter = 3.3,
    box_length = 89.15,
    box_width = 41.79
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

        //battery box mount holes
        //clockwise from bottom left
        translate([
            plate_length * 10 / 2 - box_length / 2 + 30,
            plate_width * 10 / 2 - box_width / 2 + 9,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 30,
            plate_width * 10 / 2 - box_width / 2 + 9 + 24,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 30 + 40,
            plate_width * 10 / 2 - box_width / 2 + 9 + 24,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);

        translate([
            plate_length * 10 / 2 - box_length / 2 + 30 + 40,
            plate_width * 10 / 2 - box_width / 2 + 9,
            0
        ])
        cylinder(d = grid_hole_diameter, h=plate_thickness*3, center=true, $fn=30);
    }
    
}