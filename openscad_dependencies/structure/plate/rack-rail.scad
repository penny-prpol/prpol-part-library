// Not Yet Productive
// Rack Rail — Server-rack-inspired plate with internal dividers
//
// A cee-based part with vertical dividers at every 3rd hole gap,
// creating slots for holding Robot Core Stack plates or similar
// components without standoffs. Y is fixed at 2, Z at 1.
//
// Use: Structural rail for stacking plates in a Robot Core assembly
// Examples:
//   - Pair of rack rails holding Robot Core Stack plates
//   - Shelf rail in a truss tower

module rack_rail(
    length = 9,              // Length in PRPOL units (should be divisible by 3)
    plate_thickness = 2.5,
    chamfer_depth = 1.0,
    hole_diameter = 3.2,
    hole_faces = 15
){
    bodyWidth = length * 10 + plate_thickness * 2;
    bodyLength = 2 * 10;
    bodyHeight = 1 * 10 + plate_thickness;

    slot_spacing = 30;  // every 3rd hole gap
    num_slots = floor(length / 3);

    rotate([90, 0, 0])
    difference(){
        chamferCube(dimensions=[bodyWidth, bodyLength, bodyHeight], chamfer_depth=chamfer_depth);

        // Cut individual slot voids, leaving plate_thickness dividers
        // at every 3rd gap between holes
        for(s = [0 : num_slots - 1]){
            void_start = (s == 0) ?
                plate_thickness :
                plate_thickness + s * slot_spacing + plate_thickness/2;
            void_end = (s == num_slots - 1) ?
                bodyWidth - plate_thickness :
                plate_thickness + (s + 1) * slot_spacing - plate_thickness/2;

            translate([void_start, -10, plate_thickness])
            cube([void_end - void_start, bodyLength + 20, 11]);
        }

        // Holes through base plate
        for(i = [0 : length - 1]){
            for(j = [0 : 1]){
                translate([plate_thickness + 5 + 10*i, 5 + 10*j, 0])
                cylinder(h = bodyHeight*3, d = hole_diameter, center = true, $fn = hole_faces);
            }
        }

        // Holes through all walls (end walls + dividers) in X direction
        for(j = [0 : 1]){
            translate([0, 5 + 10*j, plate_thickness + 5])
            rotate(90, [0,1,0])
            cylinder(h = bodyWidth*3, d = hole_diameter, center = true, $fn = hole_faces);
        }
    }
}
