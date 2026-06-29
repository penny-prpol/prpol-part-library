// ── marble / track constants ──────────────────────────────────────────────────
marble_diameter  = 16;
marble_radius    = marble_diameter / 2;          // 8mm
track_inner_diameter = 18;
track_inner_radius   = track_inner_diameter / 2; // 9mm
track_wall_thickness = 2;
// marble center sits at marble_radius above the trough inner floor;
// trough inner floor is track_wall_thickness above the path spine
marble_center_z_above_spine = track_wall_thickness + marble_radius;  // 10mm

// ── blocking wall parameters ──────────────────────────────────────────────────
wall_y           = 20;   // Y position of blocking wall — ~20mm from downstream end (Y=0)
wall_thickness_y = 3;     // wall thickness in Y — narrow enough not to jam two marbles
// Wall height measured from trough inner floor.
wall_height      = 5;     // height of blocking wall above trough inner floor (mm)

// Z of the path spine at wall_y (straight track formula: z = 5 + (y/200)*10)
wall_spine_z     = 5 + (wall_y / 200) * 10;
// Z of trough inner floor at wall_y
wall_floor_z     = wall_spine_z + track_wall_thickness;

// ── lifter pocket parameters (floor opening upstream of wall) ─────────────────
lifter_pocket_width  = marble_diameter + 1;  // 18mm — across the track (X), 2mm wider than marble
lifter_pocket_length = marble_diameter + 1;  // 17mm — along the track (Y), 1mm longer than marble
// Center the pocket on the first marble in the queue: one radius upstream of the wall face
lifter_pocket_y_center = wall_y + wall_thickness_y / 2 + marble_radius;
// Z of path spine at the pocket center
lifter_pocket_spine_z  = 5 + (lifter_pocket_y_center / 200) * 10;

// ── drop tube parameters ──────────────────────────────────────────────────────
drop_tube_inner_radius    = marble_radius + 1;           // 9mm — 1mm clearance around marble
drop_tube_wall_thickness  = 2;
drop_tube_outer_radius    = drop_tube_inner_radius + drop_tube_wall_thickness;  // 11mm
drop_tube_height          = 60;
drop_tube_y_clearance     = 3;  // extra gap between tube near-face and Y=0 mount hole
drop_tube_y_center        = drop_tube_outer_radius + drop_tube_y_clearance;  // 14mm
// tube top is flush with the top of the trough at Y=0 (spine z=5, trough inner top z=25)
drop_tube_top_z           = 5 + track_wall_thickness + track_inner_diameter;   // 25mm
drop_tube_bottom_z        = drop_tube_top_z - drop_tube_height;                // -35mm
// Z of the marble center in the trough at the drop tube Y location (local piece-2 coords)
// spine z = 5 + (y/200)*10; marble center = spine + wall + marble_radius
drop_tube_entrance_z = 5 + (drop_tube_y_center / 200) * 10 + track_wall_thickness + marble_radius;
// lever slot through +Y wall of drop tube
lever_slot_width  = 5;   // mm, centered on x=12
lever_slot_top_z  = drop_tube_entrance_z - marble_radius;  // = inner trough floor at drop_tube_y_center

// ── lever geometry (world-space) ──────────────────────────────────────────────
// Piece 2 assembled offset [0, -200, -10]: convert piece-2-local to world coords
drop_tube_world_y          = drop_tube_y_center - 200;           // ≈ -186mm
drop_tube_entrance_world_z = drop_tube_entrance_z - 10;          // ≈   5.7mm

// Marble center Z at rest in trough at the lifter pocket (world coords):
//   trough inner floor = spine_z + track_wall_thickness
//   marble sits in curved trough: center is (inner_radius - marble_radius) above floor
lifter_marble_center_z = lifter_pocket_spine_z + track_wall_thickness
                       + (track_inner_radius - marble_radius);   // ≈ 9.5mm
// Wall top Z (world):
wall_top_z = wall_floor_z + wall_height;                         // ≈ 13mm
// Required lifter stroke: marble center must clear wall top + margin.
// Computed value ≈ 4.5mm; 6mm used for safety.
lifter_stroke = 6;   // mm

// Lifter-side arm length (pivot to lifter pocket center along the arc).
// Longer = more linear lifter motion.
lifter_arm_length = 80;   // mm

// Lever bar cross-section
lever_bar_width         = 6;   // mm — bar extent in X
lever_bar_cross_section = 4;   // mm — bar depth (square cross-section)

// Pivot boss geometry
pivot_boss_outer_radius = 4;                          // mm
pivot_boss_total_length = lever_bar_width + 12;       // 6mm overhang each side = 18mm
pivot_hole_radius       = 0.875 + 0.1;               // filament radius + clearance

// Pivot world-space position (centered on track X=12)
pivot_world_y = lifter_pocket_y_center - lifter_arm_length;   // ≈ -50.5mm
pivot_world_z = -5;   // mm — below both track floors

// Arm A: pivot → lifter pocket (Y and Z offsets in world space)
arm_a_offset_y = lifter_pocket_y_center - pivot_world_y;     // = lifter_arm_length ≈ 80mm
arm_a_offset_z = (lifter_pocket_spine_z + track_wall_thickness) - pivot_world_z;  // ≈ 13.5mm

// Arm B: pivot → drop tube entrance (Y and Z offsets in world space)
arm_b_offset_y = drop_tube_world_y - pivot_world_y;          // ≈ -135.5mm
arm_b_offset_z = drop_tube_entrance_world_z - pivot_world_z; // ≈  10.7mm

// Paddle arm Euclidean length
paddle_arm_length = sqrt(arm_b_offset_y * arm_b_offset_y + arm_b_offset_z * arm_b_offset_z);

// Angular travel produced by the target lifter stroke
lever_angle_degrees = asin(lifter_stroke / lifter_arm_length);  // ≈ 4.3°

// Resulting downward paddle travel
paddle_stroke = abs(arm_b_offset_y) * sin(lever_angle_degrees); // ≈ 10.2mm

// ── assembly ──────────────────────────────────────────────────────────────────
module marble_flow_regulator() {

    // ── piece 1: magazine ─────────────────────────────────────────────────────
    difference() {
        union() {
            // straight track body
            straight_marble_track();

            // blocking wall spanning the full width of the pocket + reinforcing prisms
            translate([12 - lifter_pocket_width / 2 - 3, wall_y - wall_thickness_y / 2, wall_floor_z])
            cube([lifter_pocket_width + 6, wall_thickness_y, wall_height]);

            // reinforcement prisms flanking the lifter pocket
            translate([12 - lifter_pocket_width / 2 - 3, lifter_pocket_y_center - lifter_pocket_length / 2, lifter_pocket_spine_z])
            cube([3, lifter_pocket_length + 5, 10]);

            translate([12 + lifter_pocket_width / 2, lifter_pocket_y_center - lifter_pocket_length / 2, lifter_pocket_spine_z])
            cube([3, lifter_pocket_length + 5, 10]);
        }

        // rectangular floor pocket for lifter — upstream side of wall
        translate([12 - lifter_pocket_width / 2, lifter_pocket_y_center - lifter_pocket_length / 2, lifter_pocket_spine_z - 10])
        cube([lifter_pocket_width, lifter_pocket_length, 50]);
    }

    // ── piece 2: drop track ───────────────────────────────────────────────────
    // straight track with a vertical drop tube at the downstream end (Y=0)
    translate([0, -200, -10])
    difference() {
        union() {
            straight_marble_track();

            // drop tube outer wall — centered on track x=12, at downstream end y=0
            translate([12, drop_tube_y_center, drop_tube_bottom_z])
            cylinder(r = drop_tube_outer_radius, h = drop_tube_height, $fn = 48);
        }

        // drop tube inner bore
        translate([12, drop_tube_y_center, drop_tube_bottom_z - 0.1])
        cylinder(r = drop_tube_inner_radius, h = drop_tube_height + 0.2, $fn = 48);

        // entrance bore — horizontal cylinder along Y, at marble-center height
        // starts at outer +Y face, extends to the tube center line
        translate([12, drop_tube_y_center + drop_tube_outer_radius + 0.1, drop_tube_entrance_z])
        rotate([90, 0, 0])
        cylinder(r = drop_tube_inner_radius, h = drop_tube_outer_radius + 0.2, $fn = 48);

        // lever slot — 5mm wide, down the +Y side, from trough floor to tube bottom
        translate([12 - lever_slot_width / 2, drop_tube_y_center, drop_tube_bottom_z - 0.1])
        cube([lever_slot_width, drop_tube_outer_radius + 0.2, lever_slot_top_z - drop_tube_bottom_z + 0.2]);
    }

    // ── piece 3: lever arm ─────────────────────────────────────────────────────
    translate([12, pivot_world_y, pivot_world_z])
    lever_arm();

}

// ── lever arm module (piece 3) ──────────────────────────────────────────
module lever_arm() {
    lifter_body_height = 14;   // mm — block depth below top face
    paddle_radius      = drop_tube_inner_radius - 0.5;  // slight clearance in bore
    paddle_height      = 3;    // mm — paddle disc thickness

    difference() {
        union() {
            // pivot boss — cylinder along X axis
            rotate([0, 90, 0])
            cylinder(r = pivot_boss_outer_radius, h = pivot_boss_total_length, center = true, $fn = 24);

            // arm A bar: pivot → lifter end
            hull() {
                rotate([0, 90, 0])
                cylinder(r = lever_bar_cross_section / 2, h = lever_bar_width, center = true, $fn = 16);

                translate([0, arm_a_offset_y, arm_a_offset_z])
                rotate([0, 90, 0])
                cylinder(r = lever_bar_cross_section / 2, h = lever_bar_width, center = true, $fn = 16);
            }

            // lifter body at arm A tip — top face flush with trough floor in rest position
            translate([0, arm_a_offset_y, arm_a_offset_z])
            translate([-lifter_pocket_width / 2, -lifter_pocket_length / 2, -lifter_body_height])
            cube([lifter_pocket_width, lifter_pocket_length, lifter_body_height]);

            // arm B bar: pivot → paddle end
            hull() {
                rotate([0, 90, 0])
                cylinder(r = lever_bar_cross_section / 2, h = lever_bar_width, center = true, $fn = 16);

                translate([0, arm_b_offset_y, arm_b_offset_z])
                rotate([0, 90, 0])
                cylinder(r = lever_bar_cross_section / 2, h = lever_bar_width, center = true, $fn = 16);
            }

            // paddle disc at arm B tip — horizontal disc blocking top of drop bore
            translate([0, arm_b_offset_y, arm_b_offset_z])
            cylinder(r = paddle_radius, h = paddle_height, center = true, $fn = 32);
        }

        // pivot hole for filament pin
        rotate([0, 90, 0])
        cylinder(r = pivot_hole_radius, h = pivot_boss_total_length + 0.2, center = true, $fn = 20);
    }
}



