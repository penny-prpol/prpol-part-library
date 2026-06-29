// In Revision

module cee(dimensions=[3,3,3], plate_thickness=2.5, chamfer_depth=1.0,hole_diameter=3.2,hole_faces=15){
    bodyWidth = dimensions[0] * 10 + plate_thickness * 2;
    bodyLength = dimensions[1] * 10;
    bodyHeight = dimensions[2] * 10 + plate_thickness;
    bodyDims = [bodyWidth,bodyLength,bodyHeight];

    difference(){
        chamferCube(dimensions=bodyDims,chamfer_depth=chamfer_depth);
        translate([plate_thickness,-10,plate_thickness]){
            cube([dimensions[0]*10,dimensions[1]*20,dimensions[2]*11]);
        }
        
        for(i = [0:dimensions[0]-1]){
            for(j = [0:dimensions[1]-1]){
                translate([plate_thickness+5+10*i,5+10*j,0]){
                    cylinder(h= bodyHeight*3, d = hole_diameter, center = true, $fn = hole_faces);
                }
            }
        }
        
        for(j = [0:dimensions[1]-1]){
            for(k = [0:dimensions[2]-1]){
                translate([0,5+10*j,plate_thickness+5+10*k]){
                    rotate(90,[0,1,0]){
                        cylinder(h=bodyWidth*3, d=hole_diameter, center = true, $fn = hole_faces);
                    }
                }
            }
        }
    }
}

