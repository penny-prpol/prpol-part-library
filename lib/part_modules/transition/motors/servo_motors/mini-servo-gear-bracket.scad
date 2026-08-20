// Mini servo gear bracket.
//
// Grid plate with a raised block that mounts a mini servo to the PRPOL
// grid (defaults to a 4x4 plate), with cutouts that leave room for a
// gear riding on the servo output shaft (see mini-servo-gear.scad).

module mini_servo_gear_bracket(
    grid_columns = 4,
    grid_rows = 4,
    plate_thickness = 5,
    screw_spacing = 27.5, // center-to-center distance between servo mounting holes
    axle_position = 8.25, // distance from the servo output axis to the center of
                          // the nearest mounting hole, aligned to the part grid
    servo_box_width = 12.11,
    servo_box_length = 22.53,
    mount_hole_diameter = 2.1,
    grid_hole_diameter = 3.2,
    axle_grid_column = 3,
    axle_grid_row = 2,
    show_axle_position = false
){
    $fn = 15;

    cutout_width = servo_box_width + 1;
    cutout_length = servo_box_length + 1;

    axle_x_position = (axle_grid_column * 10) - 5;
    axle_y_position = (axle_grid_row * 10) - 5;

    if (show_axle_position == true) {
        translate([axle_x_position, axle_y_position, 0]) {
            color("red")
            cylinder(h=100, d=2, center=true);
        }
    }

    difference(){
        union(){
            cube([grid_columns*10, grid_rows*10, plate_thickness]);
            translate([0, 20, 0]) cube([40, 20, 20]);
        }

        translate([-10, 30, -10])
        cube([60, 20, 50]);

        translate([20, 0, plate_thickness])
        cube([30, 60, 60]);

        translate([-1, axle_y_position-cutout_width/2, plate_thickness]){
            cube([100, cutout_width, 100]);
        }

        for (i = [0:1]) {
            translate([5+i*10*(grid_columns-1), 0, 15])
            rotate(90, [1,0,0])
            cylinder(h=200, d=grid_hole_diameter, center=true);
        }

        translate([axle_x_position, axle_y_position, 0]){
            translate([axle_position, 0, 0]){
                cylinder(d=mount_hole_diameter, h=100, center=true);
            }
            translate([axle_position - screw_spacing, 0, 0]){
                cylinder(d=mount_hole_diameter, h=100, center=true);
            }
            translate([axle_position - (screw_spacing/2), 0, 0]){
                cube([cutout_length, cutout_width, 100], center=true);
            }
        }

        for (i = [0:grid_columns-1]){
            for (j = [0:grid_rows-1]){
                if (!(((i==((axle_x_position-5)/10)-2) && (j==(axle_y_position-5)/10)) || ((i==((axle_x_position-5)/10)+1) && (j==(axle_y_position-5)/10)))){
                    translate([5+i*10, 5+j*10, 0]){
                        cylinder(d=grid_hole_diameter, h=100, center=true);
                    }
                }
            }
        }
    }
}