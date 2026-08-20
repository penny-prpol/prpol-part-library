
# no global variables in any .scad file in lib/ 

- all variables must be inside a module definition. 
- if a variable is defined outside a module definition, it will 
automatically be global in scope no matter which .scad file it's in.

# no module calls in any .scad file in lib/

- module definitions only, no module calls. 
- use an "endpoint" .scad file that includes prpol-header.scad,
e.g. my-first-project.scad to call modules. 

# case and abbreviation conventions

- .scad file names are in kebab-case, no capitalization

- folder names are in snake_case, no capitalization
- variable names are in snake_case, no capitalization
- module names are in snake_case, no capitalization

- avoid abbreviation or abstraction with folder, file, and variable names.

example:

BAD:        circle_d = 3; 
BETTER:     circle_diameter = 3;

- there are much better ways to manage line length, most notably by taking 
advantage of openscad's typical curly-bracket language syntax.

example:

BAD:    cube([such_and_such + 7, other_thing + something_else, yet_another / 2]);

BETTER: cube(
            [
                such_and_such + 7,
                other_thing + something_else,
                yet_another / 2
            ]
        );

BAD: translate(...)cube(...);

BETTER: translate(...)
        cube(...);




## Folder structure

```
prpol-part-library/
├── prpol-header.scad          ← the single entry point
└── lib/
    ├── _head/lib-header.scad
    ├── global_basal_modules/ ← GLOBAL basal modules: building blocks used
    │                             by many categories (global_chamfer_cube,
    │                             global_trough_extrude, ...)
    │   ├── _head/global-basal-modules-header.scad
    │   ├── internal/          ← basal module files
    │   └── vendor/            ← third-party code
    └── part_modules/          ← user-facing parts, grouped by category
        ├── _head/...
        ├── structure/
        │   ├── _head/structure-header.scad
        │   ├── plate/         ← part files live flat in their folder
        │   └── truss/
        │       ├── _head/truss-header.scad
        │       ├── truss_basal_modules/  ← LOCAL basal modules used only by
        │       │                             truss parts (connection pocket)
        │       └── truss_panels/   ← subfolders only when parts are grouped
        ├── motion/
        ├── transition/
        ├── specialty/
        └── tools/
```


## Basal modules: global vs local

- **Global basal modules** live in `lib/global_basal_modules/` and are building
  blocks useful across many categories (`global_chamfer_cube`, `global_trough_extrude`).
- **Local basal modules** live in a `<category>/<category>_basal_modules/` folder
  and are building blocks specific to that category (e.g.
  `truss/truss_basal_modules/truss-connection-pocket.scad` and
  `truss-clover-cam.scad`). 
- **Module names carry their locality**: global basal modules are prefixed with
  `global_` (`global_chamfer_cube`), local basal modules with their category
  (`truss_connection_pocket`, `truss_clover_cam`). File names mirror the module
  in kebab-case (`global-polyhedra.scad`, `truss-connection-pocket.scad`).

## Header files

- Every folder gets a `_head/` subfolder containing its single header file.
- Header file names stay **unique** and describe the folder: `plate-header.scad`,
  `servo-motors-header.scad`, `dc-motor-130-header.scad`. Never a bare
  `header.scad`.
- `_head/` folders are also a good home for `.md` documentation files
  (e.g. `truss/_head/TRUSS-README.md`). Keep docs close to the code they describe.
- A header includes only:
  - the header files of its direct child folders, and
  - its own sibling module files (via `../`).
- Headers chain one level at a time. The root `prpol-header.scad` is the only
  entry point, and everything must be reachable from it.

Example:

```
plate/
├── _head/
│   └── plate-header.scad       # include <../flat.scad> ... include <../vee.scad>
├── flat.scad
└── vee.scad
```

## Include paths

**Only header files contain `include` statements** — module files never do.
Everything resolves through the `prpol-header.scad` chain. The only exceptions
are third-party vendor code.

Paths resolve relative to the file containing the `include` line:

- same folder → `include <flat.scad>`
- one level up → `include <../flat.scad>`
- child folder's header → `include <truss/_head/truss-header.scad>`

## Naming

- Files: kebab-case (`dc-motor-130-down-bracket.scad`)
- Modules: snake_case (`dc_motor_130_down_bracket`)
- Human-readable names only — no abbreviations.
- Prefer `rotate(angle, vector)` over `rotate([a,b,c])`.

## Module rules

- The library contains **module definitions only** — never top-level module
  calls. The user calls modules from their own files (like `my-first-project.scad`).
- One module per file, except closely related wrappers.
- Keep files short; split before a file grows long.


