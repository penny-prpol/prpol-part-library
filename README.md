# Quickstart
1. **Download and install OpenSCAD from [openscad.org](https://openscad.org/).** OpenSCAD is a program that generates 3D models from code.
2. **Clone or download this repository onto your computer.** [github's helpful article if you don't know how](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github)
3. **Start OpenSCAD, choose Open, navigate to your copy of this repository on your machine, and select prpol.scad.** You can think of prpol.scad as your workspace for generating parts. It has special include statements that link it to all the other PRPOL .scad files that enable using PRPOL modules inside OpenSCAD. You will also find a collection of usage examples as a comment in prpol.scad.
4. **Below the last include statement, type bin(); then find and press Render below the 3D viewport or hit F6.** Congratulations, you've just generated your first PRPOL part. Next try typing bin([2,3,4]); instead of bin(); and press Render again. Congratulations! You've just customized your first PRPOL part!
5. **To export an STL file in OpenSCAD, go to File >> Export >> Export as STL.** Keep in mind that you must Render the model before you can export.

# PRPOL Is An Open-Source Library of 3D Printable Parts.
The PRPOL part system is designed for STEM students and teachers, hobbyists, makers, builders, and designers of all stripes.
Build anything from robots to camera rigs to lab fixtures with parts you can customize and print at home.
Dis-assemble and re-use the parts you make, and build a collection over time to make every new build faster than the last.

## Structure Parts
PRPOL structure parts are designed to be simple, durable, and easy to print. The dimensional basis of all structural parts is 3mm holes on a 10mm grid. Metric M3 machine screws and nuts are the primary method for attaching structural parts together. Each 3mm hole in PRPOL structure parts can also serve as a bushing for a 3mm round steel rod. 

### Block
Block structure parts are solid rectangular blocks with 3mm diameter holes on a 10mm grid on each side. Holes go all the way through the block. At opposite ends, there are pockets where you can insert an M3 nut after printing, so that an M3 machine screw can thread into the end of the block. 

### Plate 
Plate parts include several flat shapes as well as thin "shells" around the corresponding-size Block part. For example, one of the Plate part types is the Bin, which you can visualize as a box with no lid. A 3 unit wide, 3 unit long, 3 unit tall Block part would be exactly 3 cm by 3 cm by 3 cm. However, a Bin that is 3 units by 3 units by 3 units is sized so that a 3 x 3 x 3 block **fits perfectly inside** the Bin. The default thickness of plate parts is 2.5 mm. 

### Truss
Whereas Block and Plate parts are joined together with M3 screws and nuts, Truss parts lock together without the need for fasteners. Truss parts include Hubs and Struts. The compact Hubs pack a lot of connective potential in a small package: A Strut can be inserted into any one of 18 connection pockets in a Hub, then the Strut is rotated 90 degrees to lock it in place. Hubs can also be printed with six M3 machine screws captive inside to allow other kinds of structural parts to be screwed directly to a Truss assembly. Truss parts are the most material and time-efficient way to make larger structures. When assembling Hubs and Struts, keep in mind that all the Hubs need to be oriented the same way. The default Strut lengths are set so that the **centers of hubs are exactly 10 cm to each adjacent hub.** The shorter Leg Strut connects adjacent hubs in a 3D cubic grid pattern, and the longer Hyp (hypotenuse) Strut connects diagonal Hubs to make the truss rigid. It is perfectly acceptable for an individual truss connection to be a bit wobbly, because as long as the truss structure has both Leg and Hyp struts, the structure as a whole will still be rigid. 

## Transition Parts

