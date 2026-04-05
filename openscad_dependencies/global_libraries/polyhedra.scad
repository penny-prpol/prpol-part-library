// Octahedron centered at the origin with vertices on the coordinate axes.
// Parameter `circumscribed_radius` is the distance from the origin to each vertex.
module octahedron(circumscribed_radius = 1){
    // vertices: +X, -X, +Y, -Y, +Z (top), -Z (bottom)
    pts = [
        [ circumscribed_radius, 0, 0],
        [-circumscribed_radius, 0, 0],
        [0,  circumscribed_radius, 0],
        [0, -circumscribed_radius, 0],
        [0, 0,  circumscribed_radius],
        [0, 0, -circumscribed_radius]
    ];

    // triangular faces (each face is a list of three vertex indices)
    faces = [
        [4, 0, 2],
        [4, 2, 1],
        [4, 1, 3],
        [4, 3, 0],
        [5, 2, 0],
        [5, 1, 2],
        [5, 3, 1],
        [5, 0, 3]
    ];

    polyhedron(points = pts, faces = faces);
}

module chamferCube(dimensions = [10,10,10], chamfer_depth = 1){
    translate([chamfer_depth,chamfer_depth,chamfer_depth])
    minkowski(){
        cube([dimensions[0]-2*chamfer_depth,dimensions[1]-2*chamfer_depth,dimensions[2]-2*chamfer_depth]);
        octahedron(circumscribed_radius=chamfer_depth);
    }
}

module chamferFrame(dimensions,frameThickness,depth){
    //where dimensions is a vector e.g. [10,20,30], frameThickness specifies how many mm thick the outer frame is, and depth is the depth of the chamfer.
    
    f=2*depth;
    g=2*frameThickness;
    
    octaPoints = [ 
                    [1,0,0],
                    [0,1,0],
                    [-1,0,0],
                    [0,-1,0],
                    [0,0,1],
                    [0,0,-1]
                ];

    octaFaces = [   
                    [0,4,1],
                    [1,4,2],
                    [2,4,3],
                    [3,4,0],
                    [0,1,5],
                    [1,2,5],
                    [2,3,5],
                    [3,0,5] 
                ];
    translate([depth,depth,depth])
    minkowski(){
        difference(){
            cube([dimensions[0]-f,dimensions[1]-f,dimensions[2]-f]);
            translate([frameThickness-f,frameThickness-f,-10])
            cube([dimensions[0]-g+f,dimensions[1]-g+f,100]);
        }
        polyhedron(octaPoints*depth, octaFaces);
    }
}