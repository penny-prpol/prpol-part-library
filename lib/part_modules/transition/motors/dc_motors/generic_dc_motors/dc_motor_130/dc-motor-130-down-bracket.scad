// ─────────────────────────────────────────────────────────────────────────────
// DC 130 motor down bracket.
//
// Holds a cylindrical 130-class hobby motor (≈20 mm diameter, ≈25 mm body)
// perpendicular to the mounting plane with the output shaft pointing toward
// the plane (antinormal), so a gear on the shaft engages the plate below.
// Two M3 mount holes on 10 mm centres, counterbored for flush screw heads.

module dc_motor_130_down_bracket(
    motor_can_length = 20,
    motor_can_diameter = 20,
    grip_wall_thickness = 1.5
){
        union(){
            translate([0,-grip_wall_thickness - motor_can_diameter / 2,22.5 - motor_can_length / 2])
            global_trough_extrude(
                length = motor_can_length / 2 + 5,
                inner_diameter = motor_can_diameter,
                left_lip_placement_angle = 135,
                right_lip_placement_angle = 45,
                wall_thickness = grip_wall_thickness
            );

            translate([-15 / 2, -25 + 7.5 - 10 - 10, 0])
            bin([1,2,2]);

            difference(){
                translate([-7.5,-15,22.5 - motor_can_length / 2])
                global_chamfer_cube([15,10,motor_can_length / 2],chamfer_depth=0.75);

                cylinder(d=motor_can_diameter,h=60,$fn = 40);
            }
            
        }
        
    
    
    
}



