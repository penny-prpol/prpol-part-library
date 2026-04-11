// In Revision

module block_frame(dimensions=[3,3],
            do_nut_pockets = true,
            nut_thickness=2.5,
            nut_width=5.5,
            nut_clearance=0.2,
            chamfer_depth=1.0,
            hole_diameter=3.2,
            hole_faces=20)
{
    h = 1;
    nut_circumscribed_diameter = nut_width / cos(30);
    bodyWidth = dimensions[0] * 10; 
    bodyLength = dimensions[1] * 10; 
    bodyHeight = h * 10;
    bodyDims = [bodyWidth,bodyLength,bodyHeight];

    difference(){
        chamferFrame(bodyDims,10,1);
        
        for(i = [0:dimensions[0]-1]){ // hole pattern || to Z near XZ plane
            translate([5+10*i,5,0])
            cylinder(h=30,d=hole_diameter,center=true,$fn=20);
        }
        
        for(i = [0:dimensions[0]-1]){ // hole pattern || to Z across from XZ plane
            translate([5+10*i,bodyLength-5,0])
            cylinder(h=30,d=hole_diameter,center=true,$fn=20);
        }
        
        for(i = [0:dimensions[1]-3]){ // hole pattern || to Z near YZ plane
            translate([5,15+10*i,0])
            cylinder(h=30,d=hole_diameter,center=true,$fn=20);
        }
        
        for(i = [0:dimensions[1]-3]){ // hole pattern || to Z across from YZ plane
            translate([bodyWidth-5,15+10*i,0])
            cylinder(h=30,d=hole_diameter,center=true,$fn=20);
        }
        
        for(i = [0:dimensions[0]-1]){ // hole pattern || to Y axis
            translate([5+10*i,0,5]){
                rotate(90,[1,0,0]){
                    cylinder(h=bodyLength*3,d=hole_diameter,center=true,$fn=20);
                }
            }
        }
        for(i = [0:dimensions[1]-1]){ // hole pattern || to X axis
            translate([0,5+10*i,5]){
                rotate(90,[0,1,0]){
                    cylinder(h=bodyWidth*3,d=hole_diameter,center=true,$fn=20);
                }
            }
        }
        if(do_nut_pockets ==true){
            translate([5-(nut_width / 2),10-(nut_thickness / 2),5-(nut_circumscribed_diameter / 2)]){
                cube([nut_width,nut_thickness,9],center = false);
            }
            translate([5-(nut_width / 2),10-(nut_thickness / 2)+bodyLength - 20,5-(nut_circumscribed_diameter / 2)]){
                cube([nut_width,nut_thickness,9],center = false);
            }
            translate([5-(nut_width / 2) + bodyWidth - 10,10-(nut_thickness / 2),5-(nut_circumscribed_diameter / 2)]){
                cube([nut_width,nut_thickness,9],center = false);
            }
            translate([5-(nut_width / 2) + bodyWidth - 10,10-(nut_thickness / 2)+bodyLength - 20,5-(nut_circumscribed_diameter / 2)]){
                cube([nut_width,nut_thickness,9],center = false);
            }
            translate([0,10,0]){
                rotate(90,[0,0,-1]){
                    translate([5-(nut_width / 2),10-(nut_thickness / 2),5-(nut_circumscribed_diameter / 2)]){
                        cube([nut_width,nut_thickness,9],center = false);
                    }
                    translate([5-(nut_width / 2),10-(nut_thickness / 2)+bodyWidth - 20,5-(nut_circumscribed_diameter / 2)]){
                        cube([nut_width,nut_thickness,9],center = false);
                    }
                }
            }
            translate([0,bodyLength,0]){
                rotate(90,[0,0,-1]){
                    translate([5-(nut_width / 2),10-(nut_thickness / 2),5-(nut_circumscribed_diameter / 2)]){
                        cube([nut_width,nut_thickness,9],center = false);
                    }
                    translate([5-(nut_width / 2),10-(nut_thickness / 2)+bodyWidth - 20,5-(nut_circumscribed_diameter / 2)]){
                        cube([nut_width,nut_thickness,9],center = false);
                    }
                }
            }
        }
    }
}


