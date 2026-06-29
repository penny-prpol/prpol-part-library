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

bodyWidth = dimensions[0]*10;
bodyLength = dimensions[1]*10;
bodyHeight = dimensions[2]*10;
bodyDims = [bodyWidth, bodyLength, bodyHeight];

nut_circumscribed_diameter = nut_width / cos(30);

nutPocketWidth = nut_thickness + nut_clearance;
nutPocketLength = nut_width + nut_clearance;
nutPocketHeight = 5 + nut_circumscribed_diameter/2 + 1;
nutPocketDims = [nutPocketWidth, nutPocketLength, nutPocketHeight];

difference(){
    chamferCube(bodyDims,chamfer_depth);
    
    //hole pattern along XZ plane
    for(i = [0:dimensions[0]-1]){
        for(j = [0:dimensions[2]-1]){
            translate([5+10*i,0,5+10*j])
            rotate(90,[1,0,0])
            cylinder(h=bodyLength*3,d=hole_diameter,center=true);
        }
    }
    
    //hole pattern along XY plane
    for(i = [0:dimensions[0]-1]){
        for(j = [0:dimensions[1]-1]){
            translate([5+10*i,5+10*j,0])
            cylinder(h=bodyHeight*3,d=hole_diameter,center=true);
        }
    }
    
    //hole pattern along YZ plane
    for(i = [0:dimensions[1]-1]){
        for(j = [0:dimensions[2]-1]){
            translate([0,5+10*i,5+10*j])
            rotate(90,[0,1,0])
            cylinder(h=bodyWidth*3,d=hole_diameter,center=true);
        }
    }
    if(do_nut_pockets == true){
        for(i=[0:dimensions[1]-1]){
            if(dimensions[2] > 1){
            translate([ 10-nutPocketWidth/2,
                        5-nutPocketLength/2 + 10*i,
                        -1])
            cube(nutPocketDims);
            }
            translate([ 10-nutPocketWidth/2,
                        5-nutPocketLength/2 + 10*i,
                        bodyHeight-nutPocketHeight+1])
            cube(nutPocketDims);
            
            translate([bodyWidth-20,0,0]){
                if(dimensions[2] > 1){
                translate([ 10-nutPocketWidth/2,
                            5-nutPocketLength/2 + 10*i,
                            -1])
                cube(nutPocketDims);
                }
                translate([ 10-nutPocketWidth/2,
                            5-nutPocketLength/2 + 10*i,
                            bodyHeight-nutPocketHeight+1])
                cube(nutPocketDims);
            }
                
        }
    }
    
}
}

