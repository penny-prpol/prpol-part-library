// ============================================================================
// TRUSS_CANON - PRIMARY MODULE
// ============================================================================
// The single source of truth for all canonical truss dimensions. Generates
// the selected parts, each at its own origin position (parts may overlap -
// use truss_set() for a display layout).
//
// Generation flags default to false, so each part is opt-in:
// - truss_canon(generate_hub=true) - hub only
// - truss_canon(generate_leg_strut=true) - leg strut only
// - truss_canon(generate_hyp_strut=true) - hyp strut only
//
// Intermediate modules (abstract_hub, abstract_strut, truss_connection_pocket) are
// internal dependencies and should not be called directly. Use the user-facing
// wrappers hub(), hyp_strut() and leg_strut() instead.
// ============================================================================

module truss_canon(
    // Hub dimensions
    cube_width=20,
    connection_depth=3,
    slop=0.3,
    do_nut_pockets=true,
    nut_thickness=2.6,
    nut_width=5.7,
    
    // Strut dimensions
    strut_legs_width=4,
    strut_toes_width=5.7,
    strut_thickness=3,
    strut_body_width=5,
    leg_separation=0.5,
    leg_separation_depth=8,
    cylinder_faces=40,
    strut_base_radius_addendum=-0.3,
    
    // Spacing
    center_to_center=100,
    
    // Generation flags - false by default, each part is opt-in
    generate_hub=false,
    generate_leg_strut=false,
    generate_hyp_strut=false
)
{
    side_length = cube_width * tan(22.5);
    layer_cutoff = side_length / sqrt(2);
    leg_strut_length = center_to_center - cube_width + (2 * connection_depth);
    hyp_strut_length = (sqrt(2) * center_to_center) - cube_width + (2 * connection_depth);

    if(generate_hub == true) {
        abstract_hub(
            do_nut_pockets=do_nut_pockets,
            nut_thickness=nut_thickness,
            nut_width=nut_width,
            cube_width=cube_width,
            connection_depth=connection_depth,
            strut_legs_width=strut_legs_width,
            slop=slop,
            strut_toes_width=strut_toes_width,
            cylinder_faces=cylinder_faces,
            strut_thickness=strut_thickness
        );
    }

    if(generate_leg_strut == true) {
        abstract_strut(
            overall_length=leg_strut_length,
            base_radius_addendum=strut_base_radius_addendum,
            strut_body_width=strut_body_width,
            strut_thickness=strut_thickness,
            strut_legs_width=strut_legs_width,
            strut_toes_width=strut_toes_width,
            connection_depth=connection_depth,
            leg_separation=leg_separation,
            leg_separation_depth=leg_separation_depth,
            cylinder_faces=cylinder_faces
        );
    }

    if(generate_hyp_strut == true) {
        abstract_strut(
            overall_length=hyp_strut_length,
            base_radius_addendum=strut_base_radius_addendum,
            strut_body_width=strut_body_width,
            strut_thickness=strut_thickness,
            strut_legs_width=strut_legs_width,
            strut_toes_width=strut_toes_width,
            connection_depth=connection_depth,
            leg_separation=leg_separation,
            leg_separation_depth=leg_separation_depth,
            cylinder_faces=cylinder_faces
        );
    }
}

// ============================================================================
// TRUSS_SET - DISPLAY LAYOUT MODULE
// ============================================================================
// Arranges the canonical parts into a neat floor-standing display. Purely for
// visualization - truss_canon() is the source of truth for dimensions.
// ============================================================================

module truss_set(){
    // Display-only offsets, matching canonical defaults (hub half-width 10,
    // strut half-thickness 1.5).
    translate([0, 0, 10])
    hub();

    translate([30, 0, 1.5])
    rotate(90, [1, 0, 0])
    leg_strut();

    translate([40, 0, 1.5])
    rotate(90, [1, 0, 0])
    hyp_strut();
}