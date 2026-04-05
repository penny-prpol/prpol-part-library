include <cloverCam.scad>

// conshaft.scad has the conshaft module, which generates the shape of the
// connection pockets in the hubs, as well as conshaftTestBlock, a helper
// module for testing different conshaft parameters.



// CONSHAFT MODULE

// Parameters:

// camBasisAddendum: A small clearance addendum to the base radius of the 
// four leaf clover shape taken on by the outer perimeter of the connection
// pocket. 

// camFactor: A small factor that controls how extreme the variation is between the 
// petals and inter-petal dips of the clover shape.

// verticalClearance: A small clearance addendum that is the default clearance between the 
// top of the strut toe and the "ceiling" of the connection pocket. If this value is too high,
// the strut will be able to wiggle up and down in the connection pocket, taking away
// rigidity from the overall structure. If it is too low, there will be excessive friction
// between the top of the strut toes and the connection pocket ceiling.

// topOrBottom: A boolean flag allowing the conshaft module to change its behavior based
// on how the conshaft is oriented in the hub. Specifically, if the conshaft is in the 
// top surface or the bottom surface of the hub, topOrBottom should be set to true.
// This will make it so the topOrBottomAddendum gets added to the verticalClearance.
// Conshafts that are on top or bottom (as opposed to the sides) need additional vertical
// clearance because of layer drooping when the printer bridges the horizontal gap.

module conshaft(verticalClearance=0,topOrBottom = false, topOrBottomAddendum = 0.2) {

    
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