module dc_motor_130_up_bracket(
    motor_can_length = 20,
    motor_can_diameter = 20,
    grip_wall_thickness = 1.5
){

        union(){
            translate([0,-grip_wall_thickness - motor_can_diameter / 2,0])
            global_trough_extrude(
                length = motor_can_length,
                inner_diameter = motor_can_diameter,
                left_lip_placement_angle = 135,
                right_lip_placement_angle = 45,
                wall_thickness = grip_wall_thickness
            );

            difference(){
                rotate(90)
                translate([-5,-25,0])
                flat([1,5]);

                translate([0,0,-1])
                cylinder(d=motor_can_diameter,h=60,$fn = 40);
            }
        
        }
        
    
    
    
}