// In Revision
include <../../../lib/internals/cloverCam.scad>

// ============================================================================
// STRUT - INTERMEDIATE MODULE
// ============================================================================
// Internal module used by truss_set() to generate leg and hyp struts.
// Do not call directly - use truss_set() instead.
// Parameters are passed from truss_set() to ensure all dimensions align.
// ============================================================================

module strut(
    overall_length,
    baseRadiusAddendum=-0.3,
    strut_body_width=12,
    strut_thickness=3.5,
    strut_legs_width=8,
    strut_toes_width=5,
    connection_depth=2,
    leg_separation=2,
    leg_separation_depth=1,
    cylinder_faces=50
){
    module strutEnd(){ //a repeated intermediate step consisting of full cylinder form of t end
       
            //bottom contact cylinder
            //cylinder(d = strut_toes_width, h = 1.5, $fn = cylinder_faces); 
            cloverCam(baseRadius = strut_toes_width/2,
                  baseRadiusAddendum= baseRadiusAddendum, 
                  camFactor=0.25,
                  height=1.5,
                  pointCount=60
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
                strutEnd();
                //top T section 
                rotate(180,[0,1,0])translate([0,0,-overall_length])strutEnd();
            }
        }
        //leg separation cuts
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
        translate([0, 0, overall_length])
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
    }
}

// Alternative strut version with simpler toe geometry (not currently used)
module cylinderToeStrut(
    overall_length,
    strut_body_width=12,
    strut_thickness=3.5,
    strut_legs_width=8,
    strut_toes_width=5,
    connection_depth=2,
    leg_separation=2,
    leg_separation_depth=1,
    cylinder_faces=50
){
    module strutEnd(){ //a repeated intermediate step consisting of full cylinder form of t end
       
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
                strutEnd();
                //top T section 
                rotate(180,[0,1,0])translate([0,0,-overall_length])strutEnd();
            }
        }
        //leg separation cuts
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
        translate([0, 0, overall_length])
        cube([leg_separation, strut_thickness * 2, leg_separation_depth * 2], center = true);
    }
}

