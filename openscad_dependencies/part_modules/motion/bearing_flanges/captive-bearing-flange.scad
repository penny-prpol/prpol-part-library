// In Revision
module captive_bearing_flange(
    bearing_outer_diameter = 16.0,
    bearing_inner_diameter = 8.0,
    bearing_thickness = 5.04,
    mount_style = "end",
    do_bore_body = true,
    bore_body_hole_diameter = 3.2
){
    wall_thickness = 2.5;
    surface_offset = 5.0;
    capture_thickness = 2.0;
    capture_extent = 1.5;
    
    diameter_clearance = 0.25;
    height_clearance = 0.1;
    
    flange_thickness = 2.5;
    flange_end_radius = 4.0;
    
    mount_hole_diameter = 3.2;
    main_cylinder_height = surface_offset + bearing_thickness + capture_thickness;
    
    //inner body parameters
    inner_body_height = capture_thickness*2 + bearing_thickness + height_clearance;
    inner_body_diameter = bearing_inner_diameter - diameter_clearance;
    
    translate([0,0,main_cylinder_height])
    rotate(180,[1,0,0])
    difference(){
        union(){
            //outer main cylinder
            cylinder(
                d=bearing_outer_diameter + 2*wall_thickness,
                h=main_cylinder_height,
                $fn= 60
            );
            if (mount_style == "center"){ //center mount flange
                
                linear_extrude(height=flange_thickness)
                hull() {
                    translate([20,0,0]) circle(r=flange_end_radius,$fn=60);
                    circle(d=bearing_outer_diameter + 2*wall_thickness,$fn=60);
                    translate([-20,0,0])circle(r=flange_end_radius,$fn=60);
                }
            }
            else if (mount_style == "end"){ //end mount flange
                linear_extrude(height=flange_thickness)
                hull() {
                    translate([40,0,0]) circle(r=flange_end_radius,$fn=60);
                    circle(d=bearing_outer_diameter + 2*wall_thickness,$fn=60);
                    
                }
            }
        }
        
        
        //central bore
        cylinder(
            d=bearing_outer_diameter - 2 * capture_extent,
            h=main_cylinder_height*3,
            center=true,
            $fn= 60
        );
        
        //interface cylinder
        translate([0,0,surface_offset])
        cylinder(
            d=bearing_outer_diameter + diameter_clearance,
            h=bearing_thickness + height_clearance,
            $fn= 60
        );
        
        //mount holes

        if (mount_style == "center"){
            translate([-20,0,0])
            cylinder(
                d=mount_hole_diameter,
                h=flange_thickness * 3,
                center = true,
                $fn= 60
            );
            
            translate([20,0,0])
            cylinder(
                d=mount_hole_diameter,
                h=flange_thickness * 3,
                center = true,
                $fn= 60
            );
        }
        else if(mount_style == "end"){
            translate([20,0,0])
            cylinder(
                d=mount_hole_diameter,
                h=flange_thickness * 3,
                center = true,
                $fn= 60
            );
            
            translate([40,0,0])
            cylinder(
                d=mount_hole_diameter,
                h=flange_thickness * 3,
                center = true,
                $fn= 60
            );
        }
        
    }
    
    if(do_bore_body == true){//separate spool-shaped body generated in the center of the bearing
        difference(){
            union(){
                //main cylinder
                cylinder(h=inner_body_height, d=inner_body_diameter, $fn=60);
                //bottom capture cylinder
                cylinder(h=capture_thickness, d=bearing_inner_diameter + 2*capture_extent,$fn=60);
                //top capture cylinder
                translate([0,0,capture_thickness + bearing_thickness + height_clearance])
                cylinder(h=capture_thickness, d=bearing_inner_diameter + 2*capture_extent,$fn=60);
            }
            cylinder(d=bore_body_hole_diameter,h=80,$fn=60,center=true);
        }
    }
}
