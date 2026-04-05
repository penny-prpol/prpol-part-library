include <../../global_libraries/polyhedra.scad>

module tube(dimensions=[3,3,3], plate_thickness=2.5, chamfer_depth=1.0,hole_diameter=3.2,hole_faces=15){
    bodyWidth = dimensions[0] * 10 + 2* plate_thickness;
    bodyLength = dimensions[1] * 10 + 2* plate_thickness;
    bodyHeight = dimensions[2] * 10;
    bodyDims = [bodyWidth,bodyLength,bodyHeight];

    difference(){
        //starting body is a chamfered cube
        chamferCube(dimensions = bodyDims,chamfer_depth = chamfer_depth);
        //a centered cutting cube creates tube shape
        translate([bodyWidth/2,bodyLength/2,0]){
        cube([dimensions[0]*10,dimensions[1]*10,bodyHeight*3],center=true);
        }
        //hole array in the XZ plane
        for(i = [0:dimensions[0]-1]){
            for(k = [0:dimensions[2]-1]){
                translate([plate_thickness+5+10*i,0,5+10*k]){
                    rotate(90, [1,0,0])
                    cylinder(h= bodyLength*3, d = hole_diameter, center = true, $fn = hole_faces);
                }
            }
        }
        //hole array in the YZ plane
        for(j = [0:dimensions[1]-1]){
            for(k = [0:dimensions[2]-1]){
                translate([0,plate_thickness + 5+10*j,5+10*k]){
                    rotate(90,[0,1,0]){
                        cylinder(h=bodyWidth*3, d=hole_diameter, center = true, $fn = hole_faces);
                    }
                }
            }
        }
    }
}
