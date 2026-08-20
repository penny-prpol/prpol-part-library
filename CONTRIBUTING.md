# Contributing to PRPOL

Thanks for helping build the Printable Robot Part Open Library! PRPOL is a
library of parametric, 3D-printable robot parts written in OpenSCAD.

## Ways to contribute

- **Request a part** — open a [Part Request](https://github.com/USERNAME/prpol-part-library/issues/new?choose=a-template) issue. Good requests get designed faster.
- **Report a problem with a part** — use the [Part Bug Report] issue template.
- **Contribute a part or fix** — see the workflow below.

## Contributing a part or a fix

1. **Fork** this repository and create a branch for your work.
2. Write your part as a single module in a new file under
   `lib/part_modules/<category>/<subcategory>/`.
3. Follow the conventions in [AGENTS.md](AGENTS.md) — in short:
   - Files are kebab-case (`dc-motor-130-down-bracket.scad`),
     modules are snake_case (`dc_motor_130_down_bracket`).
   - Only module definitions — never top-level module calls.
   - Human-readable variable names, no abbreviations.
   - Prefer `rotate(angle, vector)` over `rotate([a,b,c])`.
   - Add your new file to the matching `*-header.scad` file.
4. Test your part locally:
   ```
   openscad --export-format=stl -o /tmp/part.stl path/to/your-file.scad
   ```
   and through the full chain:
   ```
   openscad --export-format=stl -o /tmp/full.stl prpol-header.scad
   ```
5. Open a **pull request**. A GitHub Action automatically parses every
   `.scad` file in the library, so broken syntax is caught before review.

## What happens next

- The maintainer reviews the PR, checks the geometry renders cleanly, and
  either requests changes or merges.
- Merged parts show up in the library and on the PRPOL website.

## Community ground rules

- Be kind and constructive. Makers of all skill levels are welcome.
- Respect the [LICENSE](LICENSE).
- If you build something on top of PRPOL, tell us about it — community
  builds are the best documentation there is.
