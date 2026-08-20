// In Revision

module arduino_uno_mount(
    dimensions = [9,6],
    plate_thickness = 2.5,
    hole_diameter = 3.2,
    chamfer_depth = 0.75,
    standoff_outer_diameter = 5.0,
    standoff_height = 4.0
){
    assert(dimensions[0] >= 9 && dimensions[1] >= 6,
     "\nInput error: When you enter a value for dimensions = [A,B] A must be >= 9 and B must be >= 6.");

    $fn=20;


    width = 10*dimensions[0];
    length = 10*dimensions[1];

    arduino_offset_x = (dimensions[0] - 9) * 10;
    arduino_offset_y = (90-68.68)/2;
    arduino_offset_z = (60-53.27)/2;

    difference(){
        union(){
            global_chamfer_cube(dimensions=[width, length, plate_thickness], chamfer_depth=chamfer_depth);
            // standoffs for the Arduino board
            translate([arduino_offset_x, 0, 0])
            translate([arduino_offset_y, arduino_offset_z, 0]){
                translate([13.97, 2.54, plate_thickness])
                    cylinder(d=standoff_outer_diameter, h=standoff_height, $fn=30);
                // highest-Y mount hole: solid standoff + alignment pin — screw head won't fit here
                translate([15.24, 50.8, plate_thickness]){
                    cylinder(d=standoff_outer_diameter, h=standoff_height, $fn=30);
                    translate([0, 0, standoff_height])
                        cylinder(d=2.8, h=1.5, $fn=30);
                }
                translate([66.04, 7.62, plate_thickness])
                    cylinder(d=standoff_outer_diameter, h=standoff_height, $fn=30);
                translate([66.04, 35.56, plate_thickness])
                    cylinder(d=standoff_outer_diameter, h=standoff_height, $fn=30);
            }
        }
        for(i = [0:1]){
            for(j = [0:dimensions[1]-1]){
                translate([5+(10*i*(dimensions[0]-1)),5+(10*j),0]){
                    cylinder(h = 10, d = hole_diameter, center = true);
                }
            }
        }
        translate([arduino_offset_x, 0, 0])
        translate([arduino_offset_y, arduino_offset_z, 0]){
            translate([13.97,2.54,0])cylinder(d= hole_diameter, h=100,center=true);
            translate([66.04,7.62,0])cylinder(d= hole_diameter, h=100,center=true);
            translate([66.04,35.56,0])cylinder(d= hole_diameter, h=100,center=true);
        }

    }
    
    
   
}


