// Final Review

module flat_angle(
    angle=60,
    length1=5,
    length2=5,
    plate_thickness=2.5,
    hole_diameter= 3.2,
    chamfer_depth = 0.6,
    hole_faces=15
)
{
    // L-shaped flat bracket with holes along the length
    // angle: the angle between the two arms (in degrees)
    // length1: length of the first arm (in mm)
    // length2: length of the second arm (in mm)
    $fn = 30;
    cylinder_height = plate_thickness - (2 * chamfer_depth);
    cylinder_diameter = 10 - (2 * chamfer_depth);

    difference(){
        minkowski(){
            union(){ //pre-minkowski main body
                hull(){
                    //center cylinder
                    cylinder(h = cylinder_height, d = cylinder_diameter);

                    //x axis cylinder
                    translate([(length1 - 1) * 10, 0 , 0])
                    cylinder(h = cylinder_height, d = cylinder_diameter);
                }
                hull(){
                    //center cylinder
                    
                    cylinder(h = cylinder_height, d = cylinder_diameter);

                    //radially placed cylinder
                    translate(
                        [(length2 - 1) * 10 * cos(angle),
                        (length2 - 1) * 10 * sin(angle),
                        0]
                    )
                    cylinder(h = cylinder_height, d = cylinder_diameter);
                }
            }
            octahedron(chamfer_depth); //chamfer-generating minkowski addition body
        }
        //center hole
        translate([0,0, -1 * plate_thickness]) 
        cylinder(d =  hole_diameter, h = plate_thickness * 3);

        //holes along x axis
        for(i = [1 : length1 - 1]){
            translate([10 * i, 0 , -1 * plate_thickness])
            cylinder(d =  hole_diameter, h = plate_thickness * 3);
        }

        //holes along radial arm
        for(i = [1 : length2 - 1]){
            translate(
                [10 * i * cos(angle),
                10 * i * sin(angle),
                -1 * plate_thickness]
            )
            cylinder(d =  hole_diameter, h = plate_thickness * 3);

        }
        
    }
    
}
