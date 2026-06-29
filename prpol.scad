include <prpol-headers.scad>

/*
================== GETTING STARTED ==================

Welcome to PRPOL! This is your workspace for generating
3D-printable parts. No coding experience needed!

STEP 1: Choose a part
Replace the command below with any part from the quick 
examples below, or visit prpol.org/docs for a full list.

STEP 2: Render the part
After changing a command, press F6 (or click the render
button below the viewport window) to generate a preview.

STEP 3: Export for 3D printing
Once you like what you see, go to:
  File > Export > Export as STL
Then save the file - it's ready to print!

*/

// Edit this line - replace with any command from below:


// Look exactly at the origin [0, 0, 0]
//$vpt = [600, 600, 50]; 

// Rotate camera 60 degrees around the X-axis and 30 degrees around the Z-axis
//$vpr = [54.7356, 0, 45]; 

// Set the camera distance to 250 units away
//$vpd = 2450; 

//platform_paneled(n=5);
//wedge_bridge_paneled(length=2);
hub_proxy_cloud();

color( "#6B3F69" ){
    //translate([-10,-10,-10])
    //chamferCube(dimensions=[20,20,20], chamfer_depth=5.857);
    
    triangle_truss_panel();
    rectangle_truss_panel();
    //square_truss_panel();
    
    //test_all_edges();
    //test_all_faces();
}

/*
Quick Examples: 

flat_angle(angle = 120);
flat_grate();
flat(dimensions=[5,5]);
bin(dimensions=[3,4,2]);
block(dimensions=[2,2,1]);
hub();
leg_strut();
hyp_strut();

Find full documentation and usage guide at prpol.org/docs
*/