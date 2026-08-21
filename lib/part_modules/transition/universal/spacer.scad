// Not Yet Productive
// Spacer — simple cylindrical spacer with an M3 through-hole
//
// Use: standoffs and spacing between parts on M3 hardware.
// Examples:
//   - lifting boards off their mounting surface
//   - spacing stacked plates apart

module spacer(
    outer_diameter = 5.5,
    inner_diameter = 3.2,
    height = 5
){
    difference(){
        cylinder(d = outer_diameter, h = height, $fn = 40);
        // through-hole, extended slightly past both ends so the cut is clean
        translate([0, 0, -0.01])
        cylinder(d = inner_diameter, h = height + 0.02, $fn = 40);
    }
}
