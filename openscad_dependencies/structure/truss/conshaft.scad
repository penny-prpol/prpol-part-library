// In Revision
include <cloverCam.scad>

// ============================================================================
// CONSHAFT - INTERMEDIATE MODULE
// ============================================================================
// Internal module used by hub() to generate connection pocket geometry.
// Do not call directly - use truss_set() instead.
// The conshaft shape (clover-shaped connection pocket) allows struts
// to be inserted and locked via 90-degree rotation.
// ============================================================================



// Parameter documentation:
// verticalClearance: Clearance between strut toe and connection pocket ceiling
// topOrBottom: If true, adds extra clearance for top/bottom pockets (layer drooping)
// topOrBottomAddendum: Extra clearance for top/bottom orientation

module conshaft(
    verticalClearance=0,
    topOrBottom=false,
    topOrBottomAddendum=0.2,
    cube_width=20,
    connection_depth=2,
    strut_legs_width=8,
    slop=0.2,
    strut_toes_width=5,
    cylinder_faces=50,
    strut_thickness=3.5
) {

    
  translate([0, 0, cube_width / 2 - connection_depth]) {
    //testcylinder - use to compare strut end radius to generated shape.
    //color("blue")translate([0,0,-0.1])cylinder(d=strut_toes_width,h=1,$fn=cylinder_faces);
    
    //main cylindrical shaft to accomodate the strut legs through a full rotation
    cylinder(d = strut_legs_width + slop, h = 10, $fn = cylinder_faces);
    //bottom connection ring. this is where the magic happens
    if(topOrBottom == true){
        cloverCam(baseRadius = strut_toes_width/2,
                  baseRadiusAddendum=0, 
                  camFactor=0.25,
                  height=1.5 + verticalClearance + topOrBottomAddendum,
                  pointCount=60
                );
    } else {
        cloverCam(baseRadius = strut_toes_width/2,
                  baseRadiusAddendum=0, 
                  camFactor=0.25,
                  height=1.5 + verticalClearance,
                  pointCount=60
                );
        
    }
    
    
    //cutting profile of the strut keyway. 
    //allows the strut to enter and exit the connection once aligned.
    intersection() {
      cube([strut_thickness + slop, 10, 20], center = true);
      cloverCam(baseRadius = strut_toes_width/2,
                  baseRadiusAddendum=0, 
                  camFactor=0.25,
                  height=10,
                  pointCount=60
                );
    }
  }
}

// Test helper module for validating conshaft parameters
module conshaftTestBlock(topOrBottom = false, camFactor = 0.1, camBasisAddendum = -0.1){
    difference(){
        translate([0,0,cube_width/2-5])
        cube([10,10,5]);
       
        translate([5,5,0])
        conshaft(topOrBottom = topOrBottom, camFactor = camFactor, camBasisAddendum = camBasisAddendum);
    }
}

//copy and paste to do two conshaft test blocks, one side-facing and one facing up.
/*
rotate(90,[1,0,0])conshaftTestBlock();
translate([15,0,0])conshaftTestBlock(topOrBottom = true);
*/