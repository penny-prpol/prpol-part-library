// ─────────────────────────────────────────────────────────────────────────────
// global_trough_extrude — linear extrusion of the marble track trough cross-section.
//
// Same 2D profile as the marble track library (specialty/marble_track):
// a U-shaped trough whose inner floor is a circular arc of `inner_diameter`,
// with a wall of `wall_thickness` all the way around, ending in rounded lips
// at the top edges. The outer diameter is derived:
//
//     outer_diameter = inner_diameter + 2 * wall_thickness
//
// The extrusion runs along +Z for `length` millimetres. The trough opens
// upward (+Y of the profile), so the extruded part is a channel.

module global_trough_extrude(
    inner_diameter           = 18,
    wall_thickness           = 2,
    length                   = 20,
    left_lip_placement_angle = 180,
    right_lip_placement_angle = 0,
    mirrored                 = false
) {
    inner_radius  = inner_diameter / 2;
    outer_diameter = inner_diameter + (2 * wall_thickness);
    outer_radius  = outer_diameter / 2;
    midwall_radius = outer_radius - wall_thickness / 2;
    lip_radius    = wall_thickness / 2;

    correction_angle = 10;
    left_stop_angle  = left_lip_placement_angle + correction_angle;
    right_stop_angle = right_lip_placement_angle - correction_angle;

    left_lip_center = [
        midwall_radius * cos(left_stop_angle),
        midwall_radius * sin(left_stop_angle) + outer_radius
    ];

    right_lip_center = [
        midwall_radius * cos(right_stop_angle),
        midwall_radius * sin(right_stop_angle) + outer_radius
    ];

    // Perimeter of the cross-section, traced in order:
    // outer arc → left rounded lip → inner arc → right rounded lip.
    outer_arc = [
        for (a = [right_stop_angle : -5 : left_stop_angle - 360])
        [outer_radius * cos(a), outer_radius * sin(a) + outer_radius]
    ];

    left_round_lip = [
        for (a = [left_stop_angle - 10 : -10 : left_stop_angle - 180 + 10])
        [left_lip_center[0] + lip_radius * cos(a),
         left_lip_center[1] + lip_radius * sin(a)]
    ];

    inner_arc = [
        for (a = [left_stop_angle : 5 : right_stop_angle + 360])
        [inner_radius * cos(a), inner_radius * sin(a) + outer_radius]
    ];

    right_round_lip = [
        for (a = [right_stop_angle + 180 - 10 : -10 : right_stop_angle + 10])
        [right_lip_center[0] + lip_radius * cos(a),
         right_lip_center[1] + lip_radius * sin(a)]
    ];

    polypoints = concat(outer_arc, left_round_lip, inner_arc, right_round_lip);

    scale([1, mirrored ? -1 : 1, 1])
        linear_extrude(height = length)
            polygon(polypoints);
}
