include <../../global_libraries/polyhedra.scad>

module flat_frame(dimensions=[3,3], plate_thickness=2.5, chamfer_depth=1.0,hole_diameter=3.2,hole_faces=15){
    bodyWidth = dimensions[0] * 10;
    bodyLength = dimensions[1] * 10;
    bodyHeight = plate_thickness;
    bodyDims = [bodyWidth,bodyLength,bodyHeight];

    //Part Generating Code
    difference(){
        chamferCube(bodyDims,chamfer_depth);
        
        translate([10,10,-10])
        cube([bodyWidth-20, bodyLength-20, 50]);
        
        for(i = [0:dimensions[0]-1]){
            for(j = [0:dimensions[1]-1]){
                translate([5+(10*i),5+(10*j),0]){
                    cylinder(h = plate_thickness*3, d = hole_diameter, center = true, $fn = hole_faces);
                }
            }
        }
    }
}
