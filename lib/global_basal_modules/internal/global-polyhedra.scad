// Octahedron centered at the origin with vertices on the coordinate axes.
// Parameter `circumscribed_radius` is the distance from the origin to each vertex.
module global_octahedron(circumscribed_radius = 1){
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

module global_chamfer_cube(dimensions = [10,10,10], chamfer_depth = 1){
    translate([chamfer_depth,chamfer_depth,chamfer_depth])
    minkowski(){
        cube([dimensions[0]-2*chamfer_depth,dimensions[1]-2*chamfer_depth,dimensions[2]-2*chamfer_depth]);
        global_octahedron(circumscribed_radius=chamfer_depth);
    }
}

module global_cylinder_along(v, d=1, h=10, sides = 20, center = false) {
    rotate(a = acos(v[2] / norm(v)), v = [-v[1], v[0], 0])
        cylinder(d = d, h = h, center = center, $fn = sides);
}

// Square pyramid with base centered on the XY plane and apex on the +Z axis.
//   base   — side length of the square base (mm)
//   height — distance from base plane to apex (mm)
module global_square_pyramid(base = 10, height = 10) {
    b = base / 2;

    points = [
        [ b,  b, 0],   // 0
        [-b,  b, 0],   // 1
        [-b, -b, 0],   // 2
        [ b, -b, 0],   // 3
        [ 0,  0, height]  // 4 — apex
    ];

    faces = [
        [0, 3, 2, 1],  // base (CCW looking from below → outward normal −Z)
        [0, 1, 4],     // +Y side
        [1, 2, 4],     // −X side
        [2, 3, 4],     // −Y side
        [3, 0, 4]      // +X side
    ];

    polyhedron(points = points, faces = faces);
}

// Inverted square pyramid with a 45° dihedral angle between base and sides.
// Apex points downward (−Z). Used for chamfering edges via difference()
//   base — side length of the square base (mm)
// Height is derived: h = base/2 gives dihedral = 45°.
// Uses cylinder with $fn=4 instead of polyhedron to work correctly in
// both preview (F5) and render (F6).
module global_chamfering_pyramid(base = 10) {
    rotate([180, 0, 0])
    rotate([0, 0, 45])
        cylinder(d1 = base * sqrt(2), d2 = 0, h = base / 2, $fn = 4);
}