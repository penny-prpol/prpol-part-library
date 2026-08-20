// ─────────────────────────────────────────────────────────────────────────────
// DC 130 motor parallel bracket.
//
// Holds a cylindrical 130-class hobby motor with its body lying parallel to
// the mounting plane, so the output shaft runs along the Y axis. The motor
// drops into the cradle from above; with the motor model's flat sides facing
// ±X (the model's default orientation, rotated -90° about X) the can clears
// the cradle lips and rests on the trough floor.

module dc_motor_130_parallel_fixed_bracket(
    motor_can_length = 20,
    motor_can_diameter = 20,
    grip_wall_thickness = 1.5,
){
    base_plate_thickness = 2.5;

    union(){
        // Base plate, 2 x 3 grid units, bolted to the PRPOL grid.
        translate([0,0,-20])
        global_chamfer_cube([10,10,10]);

        // Cradle: the same trough profile as the up and down brackets,
        // rotated so the channel runs along Y. The cradle bottom is sunk
        // 1 mm into the base plate for a solid overlap.
        translate([0,motor_can_length,-grip_wall_thickness - motor_can_diameter / 2])
        rotate(90, [1,0,0])
        global_trough_extrude(
            length = motor_can_length,
            inner_diameter = motor_can_diameter,
            left_lip_placement_angle = 135,
            right_lip_placement_angle = 45,
            wall_thickness = grip_wall_thickness
        );
    }
}
