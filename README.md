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
PRPOL structure parts are designed to be simple, durable, and easy to print. The basis of all structural parts is: 3mm holes on a 10mm grid. 

### Plate 

