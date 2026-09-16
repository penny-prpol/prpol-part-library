// Catapult projectile — a sphere with a flat bottom face for stable printing.

module catapult_projectile(
    diameter = 25,
    flatcut_height = 1.2,
    echo_parameters = true
){
    if (echo_parameters) {
        echo(str("catapult_projectile(diameter=", diameter, ", flatcut_height=", flatcut_height, ")"));
    }
    $fn = 60;

    difference(){
        sphere(d = diameter);
        translate([0, 0, -(diameter / 2) + flatcut_height - diameter]){
            cube([2 * diameter, 2 * diameter, 2 * diameter], center = true);
        }
    }
}