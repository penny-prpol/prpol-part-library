// Final Review

module flat_angle(
    angle=60,
    length1=5,
    length2=5,
    plate_thickness=2.5,
    hole_diameter= 3.2,
    chamfer_depth = 0.75,
    hole_faces=15
)
{
    // L-shaped flat bracket with holes along the length
    // angle: the angle between the two arms (in degrees)
    // length1: length of the first arm (in units)
    // length2: length of the second arm (in units)
    $fn = 30;

    difference(){
        union(){
            hull(){
                //center cylinder
                global_chamfer_cylinder(d = 10, h = plate_thickness, chamfer_depth = chamfer_depth);

                //x axis end cylinder
                translate([(length1 - 1) * 10, 0 , 0])
                global_chamfer_cylinder(d = 10, h = plate_thickness, chamfer_depth = chamfer_depth);
            }
            hull(){
                //center cylinder
                global_chamfer_cylinder(d = 10, h = plate_thickness, chamfer_depth = chamfer_depth);

                //radially placed end cylinder
                translate(
                    [(length2 - 1) * 10 * cos(angle),
                    (length2 - 1) * 10 * sin(angle),
                    0]
                )
                global_chamfer_cylinder(d = 10, h = plate_thickness, chamfer_depth = chamfer_depth);
            }
        }
        //center hole
        translate([0,0, -1 * plate_thickness]) 
        cylinder(d =  hole_diameter, h = plate_thickness * 3, $fn = hole_faces);

        //holes along x axis
        for(i = [1 : length1 - 1]){
            translate([10 * i, 0 , -1 * plate_thickness])
            cylinder(d =  hole_diameter, h = plate_thickness * 3, $fn = hole_faces);
        }

        //holes along radial arm
        for(i = [1 : length2 - 1]){
            translate(
                [10 * i * cos(angle),
                10 * i * sin(angle),
                -1 * plate_thickness]
            )
            cylinder(d =  hole_diameter, h = plate_thickness * 3, $fn = hole_faces);

        }
        
    }
    
}
