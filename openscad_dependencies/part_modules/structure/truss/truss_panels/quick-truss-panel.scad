// ============================================================================
// QUICK-TRUSS-PANEL — spiral-slot cam locking panel for truss structures
// ============================================================================
// A square truss panel with a print-in-place quick-attach mechanism.  A central
// cam disc with four Archimedean spiral slots drives four locking rods outward
// along the panel diagonals into the hub strut-attachment pockets.  One 90° turn
// locks or unlocks all four corners simultaneously.  No springs — the spiral
// slots positively drive the rods in both directions.
//
//   hub_spacing — center-to-center hub distance (default 100 mm)
//   rod_throw   — linear travel of each rod (default 8 mm)
// ============================================================================


// ============================================================================
// INTERNAL: spiral geometry helpers
// ============================================================================

// Generate an Archimedean spiral arc as a point list
function _spiral_arc(r1, r2, a1, a2, n = 80) = [
    for (i = [0 : n])
        let(
            t  = i / n,
            r  = r1 + (r2 - r1) * t,
            a  = a1 + (a2 - a1) * t
        )
        [r * cos(a), r * sin(a)]
];

// Place a chain of thin blocks along a spiral arc to approximate
// a slot of constant width.  Good enough for FDM tolerances at n ≥ 60.
module _spiral_slot_blocks(r1, r2, a1, a2, slot_w, slot_h, n = 80) {
    a1r = a1 * PI / 180;
    a2r = a2 * PI / 180;
    a_const = (r2 - r1) / (a2r - a1r);

    for (i = [0 : n - 1]) {
        t      = i / n;
        t_next = (i + 1) / n;
        r      = r1 + (r2 - r1) * t;
        a      = a1r + (a2r - a1r) * t;
        r_next = r1 + (r2 - r1) * t_next;
        a_next = a1r + (a2r - a1r) * t_next;

        // midpoint of this tiny segment
        cx = (r * cos(a) + r_next * cos(a_next)) / 2;
        cy = (r * sin(a) + r_next * sin(a_next)) / 2;

        // tangent direction at midpoint
        r_mid = (r + r_next) / 2;
        a_mid = (a + a_next) / 2;
        tx = a_const * cos(a_mid) - r_mid * sin(a_mid);
        ty = a_const * sin(a_mid) + r_mid * cos(a_mid);
        tang = atan2(ty, tx);

        // approximate chord length
        dx = r_next * cos(a_next) - r * cos(a);
        dy = r_next * sin(a_next) - r * sin(a);
        seg_len = norm([dx, dy]);

        translate([cx, cy, 0])
        rotate([0, 0, tang])
            cube([seg_len + 0.05, slot_w, slot_h], center = true);
    }
}


// ============================================================================
// INTERNAL: cam disc
// ============================================================================
// Central rotating disc with four Archimedean spiral slots.
// Disc sits centred at the panel centre in XY; extends upward in +Z.

module _cam_disc(
    hub_spacing = 100,
    r_min       = 12,
    r_max       = 20,
    slot_w      = 3.0,
    disc_thick  = 3,
    hex_socket  = true
) {
    disc_r = r_max + 2;
    cx = hub_spacing / 2;
    cy = hub_spacing / 2;

    // Slot angular ranges [a_retracted, a_extended] on the disc.
    // When the disc rotates +90° CCW (α: 0→90°), a rod at fixed panel-angle θ
    // sees the disc-angle under it sweep from φ=θ down to φ=θ−90°.
    // So each slot runs from a1=θ (r=r_min, retracted) to a2=θ−90° (r=r_max,
    // extended).  Rod panel-angles: SW=225, SE=315, NE=45, NW=135.
    slot_angles = [
        [225, 135],   // SW rod
        [315, 225],   // SE rod
        [ 45, -45],   // NE rod
        [135,  45]    // NW rod
    ];

    difference() {
        // disc body
        translate([cx, cy, 0])
            cylinder(d = disc_r * 2, h = disc_thick, $fn = 80);

        // spiral slots
        for (sa = slot_angles) {
            translate([cx, cy, 0])
            _spiral_slot_blocks(
                r1 = r_min, r2 = r_max,
                a1 = sa[0], a2 = sa[1],
                slot_w = slot_w,
                slot_h = disc_thick + 0.1,
                n = 80
            );
        }

        // rounded terminations — r_min at a1, r_max at a2
        for (sa = slot_angles) {
            a1_rad = sa[0] * PI / 180;
            a2_rad = sa[1] * PI / 180;

            translate([cx + r_min * cos(a1_rad),
                       cy + r_min * sin(a1_rad),
                       -0.05])
                cylinder(d = slot_w, h = disc_thick + 0.2, $fn = 24);

            translate([cx + r_max * cos(a2_rad),
                       cy + r_max * sin(a2_rad),
                       -0.05])
                cylinder(d = slot_w, h = disc_thick + 0.2, $fn = 24);
        }

        // central hex socket (for M3 / 6 mm hex key)
        if (hex_socket) {
            translate([cx, cy, disc_thick - 4])
                cylinder(d = 6, h = 5, $fn = 6);
        }
    }
}


// ============================================================================
// INTERNAL: locking rod
// ============================================================================
// A single locking rod that slides along a diagonal guide channel.
// The boss pin at the inner end rides in the cam disc spiral slot.
// The outer tip is a rounded cylinder that enters the hub pocket.

module _locking_rod(
    rod_len      = 48,
    rod_w        = 4,
    rod_h        = 3,
    pin_d        = 2.4,
    pin_h        = 3,
    pin_inset    = 3,
    tip_d        = 4.3,
    tip_len      = 8,
    diagonal_ang = 225,
    hub_spacing  = 100,
    extended     = false
) {
    cx = hub_spacing / 2;
    cy = hub_spacing / 2;

    r_min = 12;      // must match _cam_disc r_min
    r_max = 20;      // must match _cam_disc r_max
    pin_r = extended ? r_max : r_min;

    a_rad = diagonal_ang * PI / 180;

    pin_x = cx + pin_r * cos(a_rad);
    pin_y = cy + pin_r * sin(a_rad);

    inner_x = cx + (pin_r - pin_inset) * cos(a_rad);
    inner_y = cy + (pin_r - pin_inset) * sin(a_rad);

    translate([inner_x, inner_y, 0])
    rotate([0, 0, diagonal_ang]) {

        // main rod body
        translate([pin_inset, 0, rod_h / 2])
            cube([rod_len, rod_w, rod_h], center = false);

        // boss pin (cylinder pointing down into the disc slot)
        translate([pin_inset, rod_w / 2, 0])
            cylinder(d = pin_d, h = pin_h, $fn = 20);

        // locking tip — rounded cylinder at the outer end of the rod
        translate([pin_inset + rod_len, rod_w / 2, rod_h / 2])
        rotate([0, 90, 0])
            cylinder(d = tip_d, h = tip_len, $fn = 30);

        // fillet transition from rod body to tip
        translate([pin_inset + rod_len - 0.5, rod_w / 2, rod_h / 2])
        rotate([0, 90, 0])
            cylinder(d1 = rod_w, d2 = tip_d, h = 1.5, $fn = 30);
    }
}


// ============================================================================
// INTERNAL: lock mechanism assembly (cam disc + 4 rods)
// ============================================================================

module _lock_mechanism_assembly(
    hub_spacing = 100,
    extended    = false
) {
    _cam_disc(hub_spacing = hub_spacing);

    rod_angles = [225, 315, 45, 135];   // SW, SE, NE, NW

    for (ang = rod_angles) {
        _locking_rod(
            diagonal_ang = ang,
            hub_spacing  = hub_spacing,
            extended     = extended
        );
    }
}


// ============================================================================
// INTERNAL: lock mechanism cutouts (negative space for panel)
// ============================================================================

module _lock_cutouts(
    hub_spacing   = 100,
    panel_z_base  = 4.14,
    panel_z_top   = 10,
    channel_depth = 3.6
) {
    cx = hub_spacing / 2;
    cy = hub_spacing / 2;

    // disc recess — cylindrical pocket in panel underside
    disc_recess_r = 22;
    disc_recess_h = 3.6;

    translate([cx, cy, panel_z_base])
        cylinder(d = disc_recess_r * 2, h = disc_recess_h, $fn = 80);

    // rod guide channels — rectangular slots along the four diagonals
    channel_w = 4.6;
    channel_start_r = 16;

    half_diag = (hub_spacing / 2) / cos(45);
    channel_len = half_diag - channel_start_r;

    rod_angles = [225, 315, 45, 135];

    for (ang = rod_angles) {
        a_rad = ang * PI / 180;
        sx = cx + channel_start_r * cos(a_rad);
        sy = cy + channel_start_r * sin(a_rad);

        translate([sx, sy, panel_z_top - channel_depth])
        rotate([0, 0, ang])
            cube([channel_len, channel_w, channel_depth + 0.1]);
    }
}


// ============================================================================
// QUICK_TRUSS_PANEL — primary module
// ============================================================================
// A square truss panel with an integrated quick-attach locking mechanism.
// All parameters from square_truss_panel are accepted and passed through.
//
//   extended       — show rods in locked (extended) position (default false)
//   lock_only      — show only the lock mechanism, no panel (default false)
//   show_cutouts   — preview the cutout negative space (default false)
// ============================================================================

module quick_truss_panel(
    // ---- panel parameters (passed to square_truss_panel) ----
    mount_holes   = true,
    gaps          = false,
    hub_width     = 20,
    hub_spacing   = 100,
    thickness     = 4,
    chamfer_depth = 0.8,

    // ---- lock mechanism parameters ----
    extended      = false,
    lock_only     = false,
    show_cutouts  = false
) {
    // derive panel Z levels (must match square_truss_panel internals)
    hub_octagon_side_length = hub_width * tan(22.5);
    hub_octagon_triangle_leg = hub_octagon_side_length / sqrt(2);
    offsetv = hub_octagon_side_length / 2;
    interface_thickness = hub_octagon_triangle_leg;
    panel_z_base = offsetv;
    panel_z_top  = offsetv + interface_thickness;

    if (lock_only) {
        // lock mechanism in isolation
        translate([0, 0, panel_z_base])
        _lock_mechanism_assembly(
            hub_spacing = hub_spacing,
            extended    = extended
        );
    } else if (show_cutouts) {
        // preview the negative space that gets subtracted from the panel
        color("red", 0.4)
        _lock_cutouts(
            hub_spacing  = hub_spacing,
            panel_z_base = panel_z_base,
            panel_z_top  = panel_z_top
        );
    } else {
        // full panel with lock mechanism
        difference() {
            square_truss_panel(
                mount_holes   = mount_holes,
                gaps          = gaps,
                hub_width     = hub_width,
                hub_spacing   = hub_spacing,
                thickness     = thickness,
                chamfer_depth = chamfer_depth
            );

            // cut lock recess and rod channels into the panel
            _lock_cutouts(
                hub_spacing  = hub_spacing,
                panel_z_base = panel_z_base,
                panel_z_top  = panel_z_top
            );
        }

        // show the lock mechanism
        translate([0, 0, panel_z_base])
        _lock_mechanism_assembly(
            hub_spacing = hub_spacing,
            extended    = extended
        );
    }
}


// ============================================================================
// QUICK TEST — uncomment to preview
// ============================================================================
/*
// full panel with lock mechanism (retracted)
quick_truss_panel();

// locked position
translate([120, 0, 0])
quick_truss_panel(extended = true);

// lock mechanism only
translate([0, 120, 0])
quick_truss_panel(lock_only = true);

// cutout preview
translate([120, 120, 0])
quick_truss_panel(show_cutouts = true);
*/
