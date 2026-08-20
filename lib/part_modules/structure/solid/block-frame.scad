// block-frame-experimental.scad
// Hollow-frame approach: union of four global_chamfer_cube beams.
// Each beam is convex, avoiding the minkowski-on-non-convex problem
// that breaks a single hollow chamfered frame with holes.
//
// The four beams overlap at the corners — union() merges them
// cleanly, and all inner/outer edges retain their chamfer.

module block_frame(
    dimensions       = [3,3],
    frame_thickness  = 10,
    do_nut_pockets   = true,
    nut_thickness    = 2.5,
    nut_width        = 5.5,
    nut_clearance    = 0.2,
    chamfer_depth    = 1.0,
    hole_diameter    = 3.2,
    hole_faces       = 20
) {
    body_width  = dimensions[0] * 10;
    body_length = dimensions[1] * 10;
    body_height = 10;  // h = 1, always 10mm tall
    t = frame_thickness;

    nut_circumscribed_diameter = nut_width / cos(30);

    difference() {

        // ── Frame body: four chamfered beams ──────────────────
        union() {
            // Top beam (along X, near +Y edge)
            translate([0, body_length - t, 0])
            global_chamfer_cube([body_width, t, body_height], chamfer_depth);

            // Bottom beam (along X, near Y=0)
            global_chamfer_cube([body_width, t, body_height], chamfer_depth);

            // Right beam (along Y, near +X edge)
            translate([body_width - t, 0, 0])
            global_chamfer_cube([t, body_length, body_height], chamfer_depth);

            // Left beam (along Y, near X=0)
            global_chamfer_cube([t, body_length, body_height], chamfer_depth);
        }

        // ── Z-parallel holes ──────────────────────────────────
        // Near XZ plane (y = 5)
        for (i = [0 : dimensions[0] - 1]) {
            translate([5 + 10*i, 5, 0])
            cylinder(h = 30, d = hole_diameter, center = true, $fn = hole_faces);
        }

        // Across from XZ plane (y = body_length - 5)
        for (i = [0 : dimensions[0] - 1]) {
            translate([5 + 10*i, body_length - 5, 0])
            cylinder(h = 30, d = hole_diameter, center = true, $fn = hole_faces);
        }

        // Near YZ plane (x = 5)
        for (i = [0 : dimensions[1] - 3]) {
            translate([5, 15 + 10*i, 0])
            cylinder(h = 30, d = hole_diameter, center = true, $fn = hole_faces);
        }

        // Across from YZ plane (x = body_width - 5)
        for (i = [0 : dimensions[1] - 3]) {
            translate([body_width - 5, 15 + 10*i, 0])
            cylinder(h = 30, d = hole_diameter, center = true, $fn = hole_faces);
        }

        // ── Y-parallel cross holes ────────────────────────────
        for (i = [0 : dimensions[0] - 1]) {
            translate([5 + 10*i, 0, 5])
            rotate(90, [1, 0, 0])
            cylinder(h = body_length * 3, d = hole_diameter,
                     center = true, $fn = hole_faces);
        }

        // ── X-parallel cross holes ────────────────────────────
        for (i = [0 : dimensions[1] - 1]) {
            translate([0, 5 + 10*i, 5])
            rotate(90, [0, 1, 0])
            cylinder(h = body_width * 3, d = hole_diameter,
                     center = true, $fn = hole_faces);
        }

        // ── Nut pockets ───────────────────────────────────────
        if (do_nut_pockets) {
            // Bottom edge, near +X
            translate([5 - nut_width/2, 10 - nut_thickness/2,
                       5 - nut_circumscribed_diameter/2])
            cube([nut_width, nut_thickness, 9]);

            // Bottom edge, far +X
            translate([5 - nut_width/2 + body_width - 10,
                       10 - nut_thickness/2,
                       5 - nut_circumscribed_diameter/2])
            cube([nut_width, nut_thickness, 9]);

            // Top edge, near +X
            translate([5 - nut_width/2,
                       10 - nut_thickness/2 + body_length - 20,
                       5 - nut_circumscribed_diameter/2])
            cube([nut_width, nut_thickness, 9]);

            // Top edge, far +X
            translate([5 - nut_width/2 + body_width - 10,
                       10 - nut_thickness/2 + body_length - 20,
                       5 - nut_circumscribed_diameter/2])
            cube([nut_width, nut_thickness, 9]);

            // Left edge — rotated 90°
            translate([0, 10, 0])
            rotate(90, [0, 0, -1]) {
                translate([5 - nut_width/2,
                           10 - nut_thickness/2,
                           5 - nut_circumscribed_diameter/2])
                cube([nut_width, nut_thickness, 9]);

                translate([5 - nut_width/2,
                           10 - nut_thickness/2 + body_width - 20,
                           5 - nut_circumscribed_diameter/2])
                cube([nut_width, nut_thickness, 9]);
            }

            // Right edge — rotated 90°
            translate([0, body_length, 0])
            rotate(90, [0, 0, -1]) {
                translate([5 - nut_width/2,
                           10 - nut_thickness/2,
                           5 - nut_circumscribed_diameter/2])
                cube([nut_width, nut_thickness, 9]);

                translate([5 - nut_width/2,
                           10 - nut_thickness/2 + body_width - 20,
                           5 - nut_circumscribed_diameter/2])
                cube([nut_width, nut_thickness, 9]);
            }
        }
    }
}
