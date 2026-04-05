include <cloverCam.scad>

module cloverToeStrut(overall_length, baseRadiusAddendum = -0.3){
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

module cylinderToeStrut(overall_length){
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

module leg_strut(){
    rotate(90,[1,0,0])
    cloverToeStrut(leg_strut_length);
}
module hyp_strut(){
    rotate(90,[1,0,0])
    cloverToeStrut(hyp_strut_length);
}