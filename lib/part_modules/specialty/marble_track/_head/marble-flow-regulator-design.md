# Marble Flow Regulator — Design Pseudocode

## Key Constants

```
marble_d = 16;          // marble diameter
marble_r = 8;           // marble radius
track_inner_d = 18;     // track trough inner diameter
track_inner_r = 9;
track_wall = 2;
track_outer_r = track_inner_r + track_wall;  // = 11
// marble rests in trough: center is at marble_r above deepest point of trough
marble_center_z = marble_r;  // ~8mm above trough floor
filament_d = 1.75;      // pivot pin
pivot_hole_d = 1.85;    // clearance fit for filament pin
```

---

## Component 1: Magazine Track + Blocking Wall

A straight track segment (modified) with a small transverse wall rising from the trough floor.

```
// Wall must be tall enough that a marble cannot roll over unassisted.
// Marble cannot self-clear a wall if wall_h >= marble_r (i.e. >= 8mm).
// Set slightly less so lifter has minimal required travel:
wall_h = marble_r - 1;  // e.g. 7mm — blocked unless center is raised past it

// Wall is a narrow ridge across the full trough width at a fixed Y position
// (call this Y = wall_y, defined relative to segment origin)
wall_y = ...;           // TBD based on full segment length
wall_thickness_y = 3;   // narrow enough not to jam two marbles

// The track floor has a slot cut at Y = lifter_y (behind the wall) through
// which the lifter body travels. Slot width = lifter_body_width + clearance.
lifter_y = wall_y - marble_d - clearance;  // one marble-diameter behind wall
slot_width = ...;       // TBD
slot_length = ...;      // TBD
```

---

## Component 2: Lifter Body (top end of lever arm A)

The lifter is the upper end of one arm of the lever. It protrudes through the slot in the track floor.

```
// Geometry in rest (down) position:
//   lifter top surface is flush with or just below trough floor
//   → marbles roll freely over the slot

// Geometry in raised position:
//   lifter top surface is at wall_h + clearance above trough floor
//   → the front marble is lifted so its center clears the wall top
//   → the lifter body width blocks the next marble in the queue

// Required lift travel:
//   marble center must rise from marble_center_z to wall_h + marble_r + clearance
lift_travel = (wall_h + marble_r + clearance) - marble_center_z;
// ≈ (7 + 8 + 1) - 8 = 8mm of vertical travel

// Lifter top face is curved/saddle-shaped to cradle one marble:
//   concave arc matching marble_r in X, flat or angled in Y

// Lifter body width in X:
lifter_width_x = marble_d + 2;  // slightly wider than marble to block queue

// Lifter body is solid below the trough floor down to the lever arm connection point.
```

---

## Component 3: Post-Wall Track (helix to drop tube)

After the marble clears the wall it enters a short helical or curved section that:
- curves in X (toward positive X) and descends in Z
- terminates at the top of the vertical drop tube

```
// Drop tube position:
drop_tube_x = helix_center_x;        // positive X from track centerline (x=12)
drop_tube_y = lifter_y;              // same Y as the lifter (lever is horizontal-ish)
drop_tube_top_z = ... ;              // below the post-wall track end, above pivot

// The post-wall helical section is a short arc (< 1 full turn) connecting:
//   start: [12, wall_y, wall_top_z + clearance]
//   end:   [drop_tube_x, drop_tube_y, drop_tube_top_z]
// Use path_extrude with same profile as standard track.
```

---

## Component 4: Vertical Drop Tube

A hollow cylinder the marble falls through. One side has a longitudinal slot for the lever paddle arm.

```
drop_tube_inner_r = marble_r + clearance;  // e.g. 9.5mm
drop_tube_wall = 2;
drop_tube_outer_r = drop_tube_inner_r + drop_tube_wall;
drop_tube_h = ...;  // tall enough for lever paddle to travel full arc

// Slot through wall (for lever paddle arm):
//   width = paddle_arm_thickness + clearance
//   runs full height of tube on the side facing the pivot
slot_face = "toward_pivot";
```

---

## Component 5: Lever Assembly

Single printed part. One pivot hole. Two arms at arbitrary angles.

```
// Arm A: lifter side
//   - points from pivot toward lifter_y (track side)
//   - length = r_A (pivot-to-lifter distance)
//   - tip = lifter body (saddle-shaped, travels vertically through slot)

// Arm B: paddle side
//   - points from pivot toward drop_tube_y
//   - length = r_B (pivot-to-paddle distance)
//   - tip = flat paddle that blocks tube interior in rest position

// Mechanical advantage condition:
//   Torque from falling marble >= Torque needed to lift stationary marble
//   marble_weight * r_B >= marble_weight * r_A   →   r_B >= r_A
//   (marble weights are equal; choose r_B > r_A for positive margin)

r_A = ...;   // TBD — constrained by lifter_y - pivot_y
r_B = ...;   // TBD — constrained by drop_tube_y - pivot_y; set r_B ≈ 1.5 * r_A

// Pivot geometry:
//   Cylindrical boss on each side of lever body, hole diameter = pivot_hole_d
//   Pivot sits in a U-bracket or two bearing posts on the track body
//   Pin = length of 1.75mm filament

// Arm angles:
//   Arm A angle from horizontal = atan2(lifter_z_at_pivot - trough_floor_z, r_A)
//   Arm B angle from horizontal = atan2(paddle_z_at_pivot - drop_tube_top_z, r_B)
//   Arms need not be collinear; total lever is one rigid printed body.

// Travel arcs:
//   Arm A tip travels lift_travel in Z  →  angular_travel = asin(lift_travel / r_A)
//   Arm B tip travels same angular_travel  →  paddle_drop = r_B * sin(angular_travel)
//   paddle_drop must be >= marble_r (paddle clears marble fully)
```

---

## Component 6: Pivot Bearing Posts

Two small posts (or integrated into the track body) that cradle the lever pivot boss.

```
// Post height positions lever pivot at correct Z
// Posts have a U-shaped slot (open top) so lever can be dropped in
// Filament pin passes through both posts and pivot boss
post_width = pivot_hole_d + 4;  // wall around hole
post_height = ...;  // pivot_z - track_floor_z
```

---

## Assembly Sequence (logical)

1. Print track body (magazine + wall + slot + post-wall helix + drop tube + bearing posts) — one piece
2. Print lever — one piece
3. Drop lever into bearing posts
4. Insert filament pin through posts + lever pivot boss
5. Trim pin flush

---

## Open Geometry Questions (to resolve before coding)

- [ ] Exact `wall_y` — depends on desired magazine capacity (how many marbles queue up)
- [ ] Exact pivot location — must satisfy both `r_A` (constrained by lifter_y) and `r_B` (constrained by drop_tube_y) simultaneously
- [ ] Drop tube height — determines how far paddle travels before marble exits bottom
- [ ] Post-wall helix shape — need entry/exit tangents to match track standard
- [ ] Whether lifter slot in track needs a floor (to limit downward travel of lifter) or lever geometry handles that
