
# the truss parts are a highly correlated part set.

The size and shape of each of the kind of part: hub, strut, and panel are
interdependent. The size of the connection pocket on a hub dictates the size of
the connecting legs on the strut. The length of the leg strut dictates the size
of the panels, etc.

Because of this, the modules in truss/ follow this pattern:

abstract part modules -> single group parameters module -> user-facing part modules

The single parametrization module, truss_canon() acts as the single source of 
truth for the precise sizing parameters for all parts in the set.

The user-facing part modules only accept parameters that a normal user would
need to set for day-to-day part generation.

A separate module, truss_set(), arranges the canonical parts
neatly for visualization or STL generation of all truss parts together.

# truss panels are still in development. 

Currently the truss panels lack a connection method to actually mechanically
connect to the hubs. This connection method will most likely be some form of 
short printed pins with the same connecting legs as a strut.

The truss panels are currently not part of the truss_canon() pipeline. 


