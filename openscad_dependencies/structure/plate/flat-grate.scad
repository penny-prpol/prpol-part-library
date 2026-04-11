// Final Review

module flat_grate(
    window_size=3,
    windows_x=3,
    windows_y=3,
    plate_thickness=2.5,
    hole_diameter=3.2,
    chamfer_depth=0.6,
    hole_faces=20
)
{
    $fn = hole_faces;
    // Flat grate with configurable window grid
    // window_size: size of each window in the grid
    // windows_x: number of windows in the X direction
    // windows_y: number of windows in the Y direction

    pre_minkowski_overall_x = 
        (window_size * 10 * windows_x) //windows 
        + (windows_x + 1) * 10 //slats
        - 2 * chamfer_depth; //minus chamfer on each side

    pre_minkowski_overall_y = 
        (window_size * 10 * windows_y) //windows 
        + (windows_y + 1) * 10 //slats
        - 2 * chamfer_depth; //minus chamfer on each side

    pre_minkowski_thickness = plate_thickness - (2 * chamfer_depth);

    difference(){
        minkowski(){
            difference(){
                translate([
                    chamfer_depth,
                    chamfer_depth,
                    0
                ])
                cube([pre_minkowski_overall_x, pre_minkowski_overall_y, pre_minkowski_thickness]);

                for(j = [0:windows_y - 1]){
                    for(i = [0: windows_x - 1]){
                        translate([
                            10 + i * (window_size * 10 + 10) - chamfer_depth,
                            10 + j * (window_size * 10 + 10) - chamfer_depth,
                            -1 * plate_thickness
                        ])
                        cube([
                            window_size * 10 + 2 * chamfer_depth,
                            window_size * 10 + 2 * chamfer_depth,
                            3 * plate_thickness
                        ]);
                    }
                }
            } 
            octahedron(chamfer_depth); //body for the minkowski sum to generate chamfers
        }
        // window corner holes
        for(j = [0 : windows_y]){
            for(i = [0: windows_x]){
                translate([
                    5 + i * (window_size * 10 + 10),
                    5 + j * (window_size * 10 + 10),
                    -1 * plate_thickness
                ])
                cylinder(d = hole_diameter, h = plate_thickness * 3);
            }
        }

        //x-parallel hole patterns
        for(j = [0: windows_y]){
            for(i = [0: windows_x - 1]){
                for(m = [0: window_size - 1]){
                    translate([
                        10 + 5 + 10 * m + i * (10 + window_size * 10),
                        5 + j * (10 + window_size * 10),
                        -1 * plate_thickness
                    ])
                    cylinder(d = hole_diameter, h = plate_thickness * 3);
                }
            }
        }

        //y-parallel hole patterns
        for(i = [0: windows_y]){
            for(j = [0: windows_x - 1]){
                for(m = [0: window_size - 1]){
                    translate([
                        5 + i * (10 + window_size * 10),
                        10 + 5 + 10 * m + j * (10 + window_size * 10),
                        -1 * plate_thickness
                    ])
                    cylinder(d = hole_diameter, h = plate_thickness * 3);
                }
            }
        }
    }
    
    
}
