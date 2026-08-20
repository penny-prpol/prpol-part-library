// In Revision


// ============================================================================
// CONNECTION POCKET - TRUSS-LOCAL BASAL MODULE
// ============================================================================
// Truss-specific basal module used by abstract_hub() to generate connection
// pocket geometry. Do not call directly - use truss_canon() instead.
// The connection pocket shape (clover-shaped) allows struts
// to be inserted and locked via 90-degree rotation.
// ============================================================================



// Parameter documentation:
// vertical_clearance: Clearance between strut toe and connection pocket ceiling
// top_or_bottom: If true, adds extra clearance for top/bottom pockets (layer drooping)
// top_or_bottom_addendum: Extra clearance for top/bottom orientation

module truss_connection_pocket(
    vertical_clearance=0,
    top_or_bottom=false,
    top_or_bottom_addendum=0.2,
    cube_width=20,
    connection_depth=3,
    strut_legs_width=4,
    slop=0.3,
    strut_toes_width=5.7,
    cylinder_faces=40,
    strut_thickness=3
) {

    
  translate([0, 0, cube_width / 2 - connection_depth]) {
    //testcylinder - use to compare strut end radius to generated shape.
    //color("blue")translate([0,0,-0.1])cylinder(d=strut_toes_width,h=1,$fn=cylinder_faces);
    
    //main cylindrical shaft to accomodate the strut legs through a full rotation
    cylinder(d = strut_legs_width + slop, h = 10, $fn = cylinder_faces);
    //bottom connection ring. this is where the magic happens
    if(top_or_bottom == true){
        truss_clover_cam(base_radius = strut_toes_width/2,
                  base_radius_addendum=0, 
                  cam_factor=0.25,
                  height=1.5 + vertical_clearance + top_or_bottom_addendum,
                  point_count=60
                );
    } else {
        truss_clover_cam(base_radius = strut_toes_width/2,
                  base_radius_addendum=0, 
                  cam_factor=0.25,
                  height=1.5 + vertical_clearance,
                  point_count=60
                );
        
    }
    
    
    //cutting profile of the strut keyway. 
    //allows the strut to enter and exit the connection once aligned.
    intersection() {
      cube([strut_thickness + slop, 10, 20], center = true);
      truss_clover_cam(base_radius = strut_toes_width/2,
                  base_radius_addendum=0, 
                  cam_factor=0.25,
                  height=10,
                  point_count=60
                );
    }
  }
}

// Test helper module for validating truss_connection_pocket parameters
module connection_pocket_test_block(top_or_bottom = false, camFactor = 0.1, camBasisAddendum = -0.1){
    difference(){
        translate([0,0,cube_width/2-5])
        cube([10,10,5]);
       
        translate([5,5,0])
        truss_connection_pocket(top_or_bottom = top_or_bottom, camFactor = camFactor, camBasisAddendum = camBasisAddendum);
    }
}

//copy and paste to do two connection pocket test blocks, one side-facing and one facing up.
/*
rotate(90,[1,0,0])connection_pocket_test_block();
translate([15,0,0])connection_pocket_test_block(top_or_bottom = true);
*/