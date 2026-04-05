include <openscad_dependencies/structure/structure-header.scad>
include <openscad_dependencies/motion/motion-header.scad>
include <openscad_dependencies/transition/transition-header.scad>
include <openscad_dependencies/specialty/specialty-header.scad>

include <openscad_dependencies/external_global_libraries/external-global-libraries-header.scad>
//copy and paste commands from the cookbook here: 

straight_marble_track();


/*
**************PRPL Quick Cookbook******************
---------------------------------------------------
All of this blue text is a big comment, meaning it
has no effect on its own. To use a command, copy
and paste it above the start of this blue text.

---A NOTE ABOUT PARAMETERS---
Parameters are optional. If a parameter is not
specified when you execute the command, it will
simply use the default value for that parameter.

e.g. bin(); makes a bin with all default parameters.

---A NOTE ABOUT NUTS---
Some parts have pockets for captive nuts. Nuts for M3
machine screws may vary slightly in size from one
manufacturer to the next. Where you see a 
parameter called nut_width, this is simply the 
distance from one flat edge of the nut to the 
opposite edge. nut_thickness is the height of 
the nut when you lay it flat on a table.

Most captive nut pockets do not require pausing the
print; the nut can be inserted after the print
is complete. However, some parts such as the 
truss hub require pausing the print at certain 
layers to insert nuts that cannot be inserted or
removed once the print is complete.

-------------STRUCTURE----------------

-----PLATE-----

example recipe with default values:
bin(
    dimensions=[3,3,3],
    plate_thickness=2.5,
    chamfer_depth=1.0,
    hole_diameter=3.2,
    hole_faces=15
);

with plate parts you typically only need to specify
the dimensions, e.g. bin(dimensions=[2,20,1]); or
simply bin([2,20,1]);

all the plate parts:
bin(); box with a floor but no lid
tube(); box with neither floor nor lid
cee(); box with no floor or lid, and one wall gone
vee(); two walls joined at a 90 degree angle
corner(); floor and two walls joined at a corner
sofa(); box with no lid and one wall removed
flat(); flat rectangle
flat_frame(); rectangle with only the crust

note: flat(); and flat_frame(); only need two
values in dimensions, e.g. [3,4].

-----SOLID-----

with solid parts you typically only need to specify
the dimensions, e.g. block(dimensions=[2,20,1]); or
simply block([2,20,1]);

full parameters and defaults:
block( //a solid rectangular prism with holes
    dimensions=[3,3,3],
    do_nut_pockets = true,
    nut_thickness=2.5,
    nut_width=5.5,
    nut_clearance=0.2,
    chamfer_depth=1.0,
    hole_diameter=3.2,
    hole_faces=20
);

block_frame( //a "picture frame" shape made of block
    dimensions=[3,3],
    do_nut_pockets = true,
    nut_thickness=2.5,
    nut_width=5.5,
    nut_clearance=0.2,
    chamfer_depth=1.0,
    hole_diameter=3.2,
    hole_faces=20
);

-----TRUSS-----

truss parts have limited parameters.

There are only three truss parts: hubs, leg struts,
and hyp struts. Hubs are the connection points
in the truss structure. The shorter leg struts connect
at right angles to form the basic cubic lattice.
Hyp (hypotenuse) struts serve as diagonal braces
in the structure and provide rigidity.

The leg and hyp struts are sized so that the centers
of adjacent hubs are exactly 10 cm apart.

To connect a strut to a hub, insert it and turn
90 degrees to lock it in place.

Keep in mind that all hubs in a truss structure
must be oriented in the same way.

Hubs have interior nut pockets by default. In order
to put nuts in these pockets, you must have pauses
in the print job at the proper layers. 

The purpose of these nut pockets is so that plate
or solid parts can be screwed directly onto hubs in 
a truss structure.

truss_set( // makes a hub, leg strut, and hyp strut.
    do_nut_pockets = true,
    nut_thickness = 2.6,
    nut_width = 5.7
);

hub( // makes a single hub
    do_nut_pockets = true,
    nut_thickness = 2.6,
    nut_width = 5.7
);

leg_strut(); // makes a leg strut.
hyp_strut(); // makes a hyp strut.

*/