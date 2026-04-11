// ============================================================================
// TRUSS_SET - PRIMARY MODULE
// ============================================================================
// This is the main module for generating truss components.
// Use this module to create hub-and-strut assemblies with unified parameters.
// All truss dimensions are defined here and passed to intermediate modules.
//
// Generation flags allow you to create:
// - truss_set() - all parts with defaults
// - truss_set(generate_hyp_strut=false) - hub and leg strut only
// - etc.
//
// Intermediate modules (hub, strut, conshaft) are internal dependencies
// and should not be called directly.
// ============================================================================

module truss_set(
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
    
    // Generation flags
    generate_hub=true,
    generate_leg_strut=true,
    generate_hyp_strut=true
)
{
    side_length = cube_width * tan(22.5);
    layer_cutoff = side_length / sqrt(2);
    leg_strut_length = center_to_center - cube_width + (2 * connection_depth);
    hyp_strut_length = (sqrt(2) * center_to_center) - cube_width + (2 * connection_depth);

    if(generate_hub) {
        translate([0, 0, 10])
        hub(
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

    if(generate_leg_strut) {
        translate([30, 0, strut_thickness / 2])
        rotate(90, [1, 0, 0])
        strut(
            overall_length=leg_strut_length,
            baseRadiusAddendum=strut_base_radius_addendum,
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

    if(generate_hyp_strut) {
        translate([40, 0, strut_thickness / 2])
        rotate(90, [1, 0, 0])
        strut(
            overall_length=hyp_strut_length,
            baseRadiusAddendum=strut_base_radius_addendum,
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