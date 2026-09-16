# Changelog

All notable changes to PRPOL are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/), and the library uses
[Semantic Versioning](https://semver.org/).

## [0.3.0] - 2026-09-16

### Added
- Every public part module now has an `echo_parameters` parameter (default
  `true`): rendering a part echoes the fully-parameterized module call to the
  OpenSCAD console, so the console line is the exact recipe for the part.
  Pass `echo_parameters = false` to silence it
- `plain_spur_gear()`: `spoke_width` parameter
- `helix_marble_track()`: `separation_distance` and `do_support_piece`
  parameters — the support piece can now be omitted or positioned further away
- `catapult_scoop()`: `scoop_extrude_radius` and `bolt_hole_diameter`
  parameters

### Changed
- OpenSCAD previews now show the same level of detail as final renders
- `mini_servo_plate_bracket()` renamed to `mini_servo_down_bracket()`
- The plate category is now divided into `shell` and `flat` parts
- `captive_bearing_flange()`: the default `mount_style` is now `"center"`
  (was `"end"`)
- `mini_servo_gear()`: the gear body now comes from `plain_spur_gear()`,
  adding spokes and matching the rest of the gear family

### Removed
- Truss panels (`square_truss_panel`, `rectangle_truss_panel`,
  `triangle_truss_panel`, `convex_edge_panel`, `concave_edge_panel`) are not
  included in this release — they will return with an improved hub connection
  in a future version
- `mini_servo_gear_bracket()` (the gear-slot servo bracket)
- The sinusoid marble track is not included in this release — it will return
  after further review and testing

### Fixed
- `arbitrary_flat()`: small surface dimples where four filled cells met in a
  block — the top surface is now smooth
- Struts: the clover-cam profile at the strut ends was missing from the
  geometry — restored
- `solid_wheel()`: nut pocket moved further from the bore, matching the gears
- Cylindrical chamfering improved in `nut_wrench()`
- Sharp edges chamfered in `catapult_scoop`
- Duplicate parameter definitions removed from `solid_wheel()`,
  `catapult_scoop()`, and `block_angle()` — the duplicates were compile
  errors that prevented those modules from rendering

## [0.2.0] - 2026-08-30

### Added
- Specialty catapult parts: `catapult_scoop()` and `catapult_projectile()`
- Marble track parts: `straight_marble_track()`, `sinusoid_marble_track()`,
  `helix_marble_track()`
- STL core library samplers for the catapult scoop and projectile

## [0.1.0] - 2026-08-24

First versioned release. The library is pre-1.0: module names, parameters, and
folder locations may still change between releases.

### Added
- Single include file to load the whole library: `prpol-header.scad`
- Global defaults: `global_default_hole_diameter`, `global_default_nut_width`,
  and `prpol_version`
- Reusable building-block modules: chamfered cubes and cylinders, polyhedra
  primitives, and trough extrusions
- Truss system: `hub()`, `hyp_strut()`, `leg_strut()`, `truss_set()`, and
  `truss_canon()` as the single source of canonical dimensions
- Universal mounting parts: `slot_plate()`, `slot_bracket()`, `spacer()`
- Gears: `plain_spur_gear()`, `compound_spur_gear()`,
  `intermittent_spur_gear()`
- `arbitrary_flat()` plates from a text layout
- STL core library — a sampler set of ready-to-print STLs
- Style guide documenting the library conventions

### Changed
- All module names are snake_case and file names kebab-case
- Hole diameter and nut width defaults now come from the global defaults

### Removed
- Board-specific mounts (Arduino, breadboard, L298N, 18650)
- `block-spur-gear` (superseded by `plain_spur_gear`)
