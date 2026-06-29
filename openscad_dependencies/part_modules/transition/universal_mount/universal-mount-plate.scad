// Not Yet Productive
// Universal Mount Plate — General-purpose electronics mounting plate
//
// A Robot Core Stack plate with alternating horizontal/vertical slots
// for continuous adjustment when mounting arbitrary circuit boards,
// battery packs, or other components. Standard PRPOL grid holes run
// along each short edge for structural attachment.
//
// Use: Attach any electronics component to the Robot Core Stack
// Examples:
//   - Battery pack mounting (any brand/size)
//   - Circuit board mounting (Arduino, ESP32, etc.)
//   - Motor driver board mounting

module universal_mount_plate(
    plate_thickness = 5,
    plate_length = 11,          // Robot Core Default (units)
    plate_width = 6,            // Robot Core Default (units)
    grid_hole_diameter = 3.3,
    slot_width = 3.3,           // Width of adjustment slots
    slot_length = 12,            // Length of adjustment slots
    chamfer_depth = 0.6
){
    body_length = plate_length * 10;
    body_width = plate_width * 10;

    // Slot grid occupies the interior, leaving 10mm strips on short edges
    // for standard PRPOL holes.
    // Slots start at x=15 (center of second column) and end at x=body_length-15.
    // Y positions on a 10mm grid, offset 5mm from edges.

    $fn = 20;

    difference(){
        chamferCube([body_length, body_width, plate_thickness], chamfer_depth = chamfer_depth);

        // PRPOL grid holes along left short edge (x = 5)
        for(i = [0 : plate_width - 1]){
            translate([5, 5 + 10*i, 0])
            cylinder(d = grid_hole_diameter, h = plate_thickness*3, center = true);
        }

        // PRPOL grid holes along right short edge (x = body_length - 5)
        for(i = [0 : plate_width - 1]){
            translate([body_length - 5, 5 + 10*i, 0])
            cylinder(d = grid_hole_diameter, h = plate_thickness*3, center = true);
        }

        // Alternating slot grid in the interior
        // Even rows (row 0, 2, ...): horizontal slots (along X)
        // Odd rows (row 1, 3, ...): vertical slots (along Y)
        // Columns start at x=15, spaced 10mm, end before x=body_length-10
        // Rows at y=5, spaced 10mm

        for(row = [0 : plate_width - 1]){
            for(col = [1 : plate_length - 2]){
                x = 5 + col * 10;
                y = 5 + row * 10;

                if((row + col) % 2 == 0){
                    // Horizontal slot (along X)
                    translate([x, y, 0])
                    hull(){
                        translate([-slot_length/2 + slot_width/2, 0, 0])
                        cylinder(d = slot_width, h = plate_thickness*3, center = true);
                        translate([slot_length/2 - slot_width/2, 0, 0])
                        cylinder(d = slot_width, h = plate_thickness*3, center = true);
                    }
                } else {
                    // Vertical slot (along Y)
                    translate([x, y, 0])
                    hull(){
                        translate([0, -slot_length/2 + slot_width/2, 0])
                        cylinder(d = slot_width, h = plate_thickness*3, center = true);
                        translate([0, slot_length/2 - slot_width/2, 0])
                        cylinder(d = slot_width, h = plate_thickness*3, center = true);
                    }
                }
            }
        }
    }
}
