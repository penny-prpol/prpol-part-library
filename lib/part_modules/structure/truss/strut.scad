// In Revision

// ============================================================================
// HYP_STRUT / LEG_STRUT - USER-FACING MODULES
// ============================================================================
// The everyday entry points for generating struts. Canonical dimensions come
// from truss_canon(); these modules take no parameters.
// ============================================================================

module hyp_strut(){
  truss_canon(generate_hyp_strut=true);
}

module leg_strut(){
  truss_canon(generate_leg_strut=true);
}

// ============================================================================
// ABSTRACT_STRUT - INTERMEDIATE MODULE
// ============================================================================
// Internal module used by truss_canon() to generate leg and hyp struts.
// Do not call directly - use truss_canon() or the wrappers above.
// All parameters are required - canonical defaults live in truss_canon() alone.
// ============================================================================

module abstract_strut(
    overall_length,
    base_radius_addendum,
    strut_body_width,
    strut_thickness,
    strut_legs_width,
    strut_toes_width,
    connection_depth,
    leg_separation,
    leg_separation_depth,
    cylinder_faces
){
    module strut_end(){ //a repeated intermediate step consisting of full cylinder form of the end
       
            //bottom contact cylinder
            //cylinder(d = strut_toes_width, h = 1.5, $fn = cylinder_faces); 
            clover_cam(base_radius = strut_toes_width/2,
                  base_radius_addendum = base_radius_addendum, 
                  cam_factor=0.25,
                  height=1.5,
                  point_count=60
                );
        
    }
    
    difference(){
        intersection(){
            cube([strut_body_width + 2, strut_thickness, overall_length * 2], center = true);
            union(){
                //main body cylinder. does not extend into connections.
                translate([0, 0, connection_depth + 1])
                cylinder(d = strut_body_width, h = overall_length - 2 - 2 * connection_depth, $fn = cylinder_faces);
                //legs cylinder
                cylinder(d = strut_legs_width, h = overall_length, $fn = cylinder_faces);
                //bottom T Section
                strut_end();
                //top T section 
                rotate(180,[0,1,0])translate([0,0,-overall_length])strut_end();
            }
        }
        //leg separation cuts
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
        translate([0, 0, overall_length])
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
    }
}

// ============================================================================
// ABSTRACT_CYLINDER_TOE_STRUT - ALTERNATE INTERMEDIATE MODULE
// ============================================================================
// Alternative strut with simpler toe geometry. Not currently used - kept for
// experiments. All parameters are required, like abstract_strut().
// ============================================================================

module abstract_cylinder_toe_strut(
    overall_length,
    strut_body_width,
    strut_thickness,
    strut_legs_width,
    strut_toes_width,
    connection_depth,
    leg_separation,
    leg_separation_depth,
    cylinder_faces
){
    module strut_end(){ //a repeated intermediate step consisting of full cylinder form of the end
       
            //bottom contact cylinder
            cylinder(d = strut_toes_width, h = 1.5, $fn = cylinder_faces); 
            
        
    }
    
    difference(){
        intersection(){
            cube([strut_body_width + 2, strut_thickness, overall_length * 2], center = true);
            union(){
                //main body cylinder. does not extend into connections.
                translate([0, 0, connection_depth + 1])
                cylinder(d = strut_body_width, h = overall_length - 2 - 2 * connection_depth, $fn = cylinder_faces);
                //legs cylinder
                cylinder(d = strut_legs_width, h = overall_length, $fn = cylinder_faces);
                //bottom T Section
                strut_end();
                //top T section 
                rotate(180,[0,1,0])translate([0,0,-overall_length])strut_end();
            }
        }
        //leg separation cuts
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
        translate([0, 0, overall_length])
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
    }
}

