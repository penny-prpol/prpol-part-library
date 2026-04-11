// In Revision
include <conshaft.scad>

// ============================================================================
// HUB - INTERMEDIATE MODULE
// ============================================================================
// Internal module used by truss_set() to generate hub components.
// Do not call directly - use truss_set() instead.
// Parameters are passed from truss_set() to ensure consistency.
// ============================================================================

module hub(
  do_nut_pockets=true,
  nut_thickness=2.6,
  nut_width=5.7,
  cube_width=20,
  connection_depth=2,
  strut_legs_width=8,
  slop=0.2,
  strut_toes_width=5,
  cylinder_faces=50,
  strut_thickness=3.5
){
  nut_circumscribed_diameter = nut_width / cos(30);
  difference(){
    //starting cube
    translate([-10,-10,-10])
    chamferCube(dimensions=[20,20,20], chamfer_depth=5.857);

    //cutting connection shafts
    for (i = [0: 45: 315]) {
      rotate(i, [0, 1, 0])
      rotate(90, [0, 0, 1])
      if(i == 0 || i == 180){
        conshaft(
          topOrBottom=true,
          cube_width=cube_width,
          connection_depth=connection_depth,
          strut_legs_width=strut_legs_width,
          slop=slop,
          strut_toes_width=strut_toes_width,
          cylinder_faces=cylinder_faces,
          strut_thickness=strut_thickness
        );
      } else {
        conshaft(
          cube_width=cube_width,
          connection_depth=connection_depth,
          strut_legs_width=strut_legs_width,
          slop=slop,
          strut_toes_width=strut_toes_width,
          cylinder_faces=cylinder_faces,
          strut_thickness=strut_thickness
        );
      }
      
    }

    for (i = [45, 90, 135, 225, 270, 315]) {
      rotate(i, [1, 0, 0])
      conshaft(
        cube_width=cube_width,
        connection_depth=connection_depth,
        strut_legs_width=strut_legs_width,
        slop=slop,
        strut_toes_width=strut_toes_width,
        cylinder_faces=cylinder_faces,
        strut_thickness=strut_thickness
      );
    }
    for (i = [45, 135, 225, 315]) {
      rotate(i, [0, 0, 1])
      rotate(90, [0, 1, 0])
      rotate(90, [0, 0, 1])
      conshaft(
        cube_width=cube_width,
        connection_depth=connection_depth,
        strut_legs_width=strut_legs_width,
        slop=slop,
        strut_toes_width=strut_toes_width,
        cylinder_faces=cylinder_faces,
        strut_thickness=strut_thickness
      );
    }

    //bottom ceiling arch sphere
    translate([0,0,-7])sphere(d=4,$fn=50);

    //if do_nut_pockets is set to true, cut the nut pockets
    if(do_nut_pockets == true){
      for(i = [0,1,2,3]){ //the four "equatorial" nut pockets
        rotate(90*i,[0,0,1])
        translate([-nut_thickness/2 + 10 - 3 - 1, 0, 0])
        cube([nut_thickness,nut_width,nut_circumscribed_diameter], center=true);
      }
      //the two "polar" nut pockets (top and bottom)
      translate([0,0,-nut_thickness + 10 - 3 - 1])
      cylinder(d=6.6,h=nut_thickness,$fn=6);

      translate([0,0,-10 + 3 + 1])
      cylinder(d=6.6,h=nut_thickness,$fn=6);

      //the cylindrical screw shafts
      cylinder(h=30,d=3.3,$fn=20, center=true);

      rotate(90,[1,0,0])
      cylinder(h=30,d=3.3,$fn=20, center=true);

      rotate(90,[0,1,0])
      cylinder(h=30,d=3.3,$fn=20, center=true);
    }
  }
}



