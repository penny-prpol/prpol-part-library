include <spurgearlib.scad>;


module plain_spur_gear(
    size = 5,
    thickness = 10,
    axis_bore_diameter = 3.2,
    chamfer_depth = 2,
    nut_clearance = 0.1,
    nut_width = 5.5,
    nut_thickness = 2.25,
    lock_bore_diameter = 3.2,
    hub_diameter = 14,
    rim_thickness = 8,
    spoke_count = 4,
    spoke_width = 4
){
    //DERIVED VALUES (NO TOUCHY)
    //main
    pitch_diameter = size*10;
    //chamfer
    chamrad = 1.5+ (pitch_diameter / 2);
    //spokes
    cutcyl_diameter = pitch_diameter-rim_thickness;
    cutcyl_height = thickness *3;
    inc=360/spoke_count;
    cd = cutcyl_diameter;
    ch = cutcyl_height;
    sw = spoke_width;
    nut_circumscribed_diameter = nut_width / cos(30);



//The meat of the codes:

difference(){
    spur_gear (modul=1, tooth_number=size*10, width=thickness, bore=axis_bore_diameter, pressure_angle=25, helix_angle=0, optimized=false);
    if(size > 3){
        difference(){
        cylinder(d=cd,h=ch,$fn=50,center=true);
        cylinder(d=hub_diameter, h=ch, $fn=50, center=true);
        for(i = [0:spoke_count-1]){
            rotate(i*inc,[0,0,1]){
                translate([cd/2,0,0]){
                    cube([cd,sw,ch+1],center=true);
                }
            }
        }
    }
    }
    
    translate([0,0,thickness-chamfer_depth]){
        difference(){
            cylinder(r=chamrad,h=thickness);
            cylinder(r1=chamrad,r2=0,h=chamrad);
        }
    }
    translate([0,0,0-thickness+chamfer_depth]){
        difference(){
            cylinder(r=chamrad,h=thickness);
            translate([0,0,0-chamrad+thickness])
            cylinder(r1=0, r2=chamrad, h=chamrad);
        }
    }
    rotate(floor(pitch_diameter/(2*spoke_count))*(360/pitch_diameter) + (360/pitch_diameter)/2){
        translate([0,0,thickness/2]){
            rotate(90,[0,1,0]){
                cylinder(h=100,d=lock_bore_diameter);
            }
        }
        translate([2.2,-(nut_width+nut_clearance)/2, thickness-(thickness/2+nut_circumscribed_diameter/2)]){
            cube([nut_thickness+nut_clearance,nut_width+nut_clearance,thickness/2+nut_circumscribed_diameter/2]);
        }
    }
    
    
}
}





