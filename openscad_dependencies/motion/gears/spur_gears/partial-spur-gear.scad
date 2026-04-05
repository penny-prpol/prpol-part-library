include <spurgearlib.scad>

module partial_spur_gear(
    size = 5,
    missing_teeth = 7,
    thickness = 10,
    axis_bore_diameter = 3.2,
    chamfer_depth = 2,
    nut_clearance = 0.1,
    nut_width = 5.5,
    nut_thickness = 2.25,
    lock_bore_diameter = 3.2,
    lock_screw_cap_diameter = 5.6,
    hub_diameter = 14,
    rim_thickness = 8,
    spoke_count = 4,
    spoke_width = 10
){
    
pitch_diameter = size*10;
chamfer_radius = 1.5+ (pitch_diameter / 2);
nut_circumscribed_diameter = nut_width / cos(30);
cutout_angle = missing_teeth * 360 / (size*10);
teeth_cutter_points = [[0,0], for(a = [0:1:cutout_angle]) [size * 20 * cos(a),size * 20 * sin(a)] ];
difference(){
    spur_gear (modul=1, tooth_number=size*10, width=thickness, bore=axis_bore_diameter, pressure_angle=25, helix_angle=0, optimized=false);
    if(size > 8){
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
            cylinder(r=chamfer_radius,h=thickness);
            cylinder(r1=chamfer_radius,r2=0,h=chamfer_radius);
        }
    }
    translate([0,0,0-thickness+chamfer_depth]){
        difference(){
            cylinder(r=chamfer_radius,h=thickness);
            translate([0,0,0-chamfer_radius+thickness])
            cylinder(r1=0, r2=chamfer_radius, h=chamfer_radius);
        }
    }
    rotate(360/(size*10)/2 + cutout_angle/2){
        translate([0,0,thickness/2]){
            rotate(90,[0,1,0]){
                cylinder(h=100,d=axis_bore_diameter);
            }
        }
        translate([2.2,-(nut_width+nut_clearance)/2, thickness-(thickness/2+nut_circumscribed_diameter/2)]){
            cube([nut_thickness+nut_clearance,nut_width+nut_clearance,thickness/2+nut_circumscribed_diameter/2]);
        }
    }
    rotate(360/(size*10)/2){
        difference(){
            linear_extrude(height=100,center=true){
                polygon(points=teeth_cutter_points);
            }
            cylinder(h=200,d=size*10 -2.28, center=true);
        }
    }
    
}


}



