
module arduino_uno_mount(
    dimensions = [9,6],
    plate_thickness = 2.5,
    hole_diameter = 3.2,
    corner_chamfer_depth = 1.0
){
    assert(dimensions[0] >= 9 && dimensions[1] >= 6,
     "\nInput error: When you enter a value for dimensions = [A,B] A must be >= 9 and B must be >= 6.");

    $fn=20;


    width = 10*dimensions[0];
    length = 10*dimensions[1];


    A= corner_chamfer_depth * -1;
    B= corner_chamfer_depth * 2;
    difference(){
        cube([width,length, 2.5]);
        for(i = [0:1]){
            for(j = [0:dimensions[1]-1]){
                translate([5+(10*i*(dimensions[0]-1)),5+(10*j),0]){
                    cylinder(h = 10, d = hole_diameter, center = true);
                }
            }
        }
        translate([(dimensions[0] - 9) * 10, 0, 0]) //positioning the arduino so the usb and power ports get extra space
        translate([(90-68.68)/2,(60-53.27)/2,0]){  //arduino mount hole pattern
            translate([13.97,2.54,0])cylinder(d= hole_diameter, h=100,center=true);
            translate([15.24,50.8,0])cylinder(d= hole_diameter, h=100,center=true);
            translate([66.04,7.62,0])cylinder(d= hole_diameter, h=100,center=true);
            translate([66.04,35.56,0])cylinder(d= hole_diameter, h=100,center=true);
        }
        linear_extrude(height = plate_thickness*2, center = true){
            polygon(points=[[A,A],[A,B],[B,A]]);
        }
        
        
        translate([width,0,plate_thickness]){
            rotate(180,[0,-1,0]){
                linear_extrude(height = plate_thickness*2,center = true){
                    polygon(points=[[A,A],[A,B],[B,A]]);
                }
            }
        }
        
        translate([width,length,0]){
            rotate(180,[0,0,1]){
                linear_extrude(height = plate_thickness*2,center = true){
                    polygon(points=[[A,A],[A,B],[B,A]]);
                }
                
                translate([width,0,plate_thickness]){
                    rotate(180,[0,-1,0]){
                        linear_extrude(height = plate_thickness*2, center = true){
                            polygon(points=[[A,A],[A,B],[B,A]]);
                        }
                    }
                }
            }
        }

    }
    
    
   
}


