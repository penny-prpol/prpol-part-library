module concave_edge_panel
union(){
square_truss_panel(gaps = true, chamfer_depth = 0.5);
    //hub_proxy_cloud();
    
    translate([0,0,100])
    rotate(90,[0,1,0])
    square_truss_panel(gaps = true, chamfer_depth = 0.5);
}
