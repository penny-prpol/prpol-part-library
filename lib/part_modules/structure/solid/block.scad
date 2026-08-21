// In Revision

module block(dimensions=[3,3,3],
            do_nut_pockets = true,
            nut_thickness=2.5,
            nut_width=5.5,
            nut_clearance=0.2,
            chamfer_depth=1.0,
            hole_diameter=3.2,
            hole_faces=20)
{
   

$fn=hole_faces;

body_width = dimensions[0]*10;
body_length = dimensions[1]*10;
body_height = dimensions[2]*10;
body_dims = [body_width, body_length, body_height];

nut_circumscribed_diameter = nut_width / cos(30);

nut_pocket_width = nut_thickness + nut_clearance;
nut_pocket_length = nut_width + nut_clearance;
nut_pocket_height = 5 + nut_circumscribed_diameter/2 + 1;
nut_pocket_dims = [nut_pocket_width, nut_pocket_length, nut_pocket_height];

difference(){
    global_chamfer_cube(body_dims,chamfer_depth);
    
    //hole pattern along XZ plane
    for(i = [0:dimensions[0]-1]){
        for(j = [0:dimensions[2]-1]){
            translate([5+10*i,0,5+10*j])
            rotate(90,[1,0,0])
            cylinder(h=body_length*3,d=hole_diameter,center=true);
        }
    }
    
    //hole pattern along XY plane
    for(i = [0:dimensions[0]-1]){
        for(j = [0:dimensions[1]-1]){
            translate([5+10*i,5+10*j,0])
            cylinder(h=body_height*3,d=hole_diameter,center=true);
        }
    }
    
    //hole pattern along YZ plane
    for(i = [0:dimensions[1]-1]){
        for(j = [0:dimensions[2]-1]){
            translate([0,5+10*i,5+10*j])
            rotate(90,[0,1,0])
            cylinder(h=body_width*3,d=hole_diameter,center=true);
        }
    }
    if(do_nut_pockets == true){
        for(i=[0:dimensions[1]-1]){
            if(dimensions[2] > 1){
            translate([ 10-nut_pocket_width/2,
                        5-nut_pocket_length/2 + 10*i,
                        -1])
            cube(nut_pocket_dims);
            }
            translate([ 10-nut_pocket_width/2,
                        5-nut_pocket_length/2 + 10*i,
                        body_height-nut_pocket_height+1])
            cube(nut_pocket_dims);
            
            translate([body_width-20,0,0]){
                if(dimensions[2] > 1){
                translate([ 10-nut_pocket_width/2,
                            5-nut_pocket_length/2 + 10*i,
                            -1])
                cube(nut_pocket_dims);
                }
                translate([ 10-nut_pocket_width/2,
                            5-nut_pocket_length/2 + 10*i,
                            body_height-nut_pocket_height+1])
                cube(nut_pocket_dims);
            }
                
        }
    }
    
}
}

