# Changelog

All notable changes to PRPOL are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/), and the library uses
[Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-08-24

First versioned release. The library is pre-1.0: module names, parameters, and
folder locations may still change between releases.

### Added
- Single-entry include chain: `prpol-header.scad` → `lib/_head/lib-header.scad`
  → category headers, with a `_head/` folder holding the unique header per folder
- Global basal modules (`lib/global_basal_modules/`): `global_chamfer_cube`,
  `global_octahedron`, `global_bicone`, `global_chamfer_cylinder`,
  `global_trough_extrude`, `global_cylinder_along`, plus polyhedra primitives
- Global default variables: `global_default_hole_diameter`,
  `global_default_nut_width`, and `prpol_version`
- Truss system: `truss_canon()` as the single source of canonical dimensions,
  user-facing `hub()`, `hyp_strut()`, `leg_strut()`, and a display-only
  `truss_set()`
- Universal mounting parts in `transition/universal/`: `slot_plate()`,
  `slot_bracket()`, `spacer()`
- Gear family refactored around `plain_spur_gear()` (spokes with holes by
  default), plus `compound_spur_gear()` and `intermittent_spur_gear()`
- `arbitrary_flat()` text-layout plate
- Style guide (`style-guide.md`) documenting the library conventions
- GitHub Actions CI that validates every file and the full header chain
- STL core library manifest and generator (in the prpol-dev repo)

### Changed
- All module names are snake_case; all files kebab-case
- Basal modules carry locality prefixes (`global_*`, `truss_*`)
- Hole diameter and nut width defaults now reference global variables
- Board-specific transition parts replaced by the universal mounting category

### Removed
- Board-specific mounts (Arduino, breadboard, L298N, 18650) — archived
- `block-spur-gear` (superseded by `plain_spur_gear`)
