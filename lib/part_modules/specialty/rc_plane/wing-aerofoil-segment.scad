// In Development

// ============================================================================
// WING AEROFOIL SEGMENT
// ============================================================================
// A parametric printable wing skin for use with the PRPOL truss spar system.
// The spar is formed from blue_edge_hubs and half-size (50 mm c-t-c) struts
// arranged in a 50 x 50 mm square cross-section at the four corners.
//
// Printed structure: outer NACA 4-series aerofoil shell and inner spar box
// tube, both open at the spanwise ends — no ribs.
//
// ── Coordinate system ────────────────────────────────────────────────────────
//   X  chordwise  (leading edge at x = 0, trailing edge at x = chord)
//   Y  thickness  (profile centred on the y = 0 chord line)
//   Z  spanwise   (segment runs from z = 0 to z = span)
//
// ── Spar void (must contain the hub-and-strut assembly) ─────────────────────
//   spar_size is NOT the hub centre-to-centre spacing.  Each blue_edge_hub
//   extends (cube_width/sqrt(2) − cube_width/2) ≈ 4.14 mm past its centre
//   on the chamfer-cut faces, so two opposing hubs add cube_width*(sqrt(2)−1)
//   to the required void width:
//
//     spar_size = spar_spacing + hub_cube_width * (sqrt(2) − 1)
//               ≈ 50 + 20 * 0.414 = 58.28 mm  (default values)
//
//   Spar void in wing coordinates:
//     x ∈ [ le_fraction·chord,  le_fraction·chord + spar_size ]
//     y ∈ [ −spar_size/2,       +spar_size/2                  ]
//
// To align the four blue_edge_hub corners with this spar void, offset the
// hub assembly (whose hub centres sit at (0,0), (s,0), (0,s), (s,s) where
// s = spar_spacing) by:
//
//   translate([ le_fraction*chord + (spar_size - spar_spacing)/2,
//               spar_y_ctr - spar_spacing/2,
//               0 ])
//
// where spar_y_ctr = naca_yc(le_fraction + spar_size/(2*chord),
//                             camber, camber_pos) * chord
// (the camber line height at the spar mid-chord, in mm).
// using the hub arrangement from the header comment in edge-hubs.scad.
// ============================================================================


// NACA 4-series symmetric half-thickness as a fraction of chord.
// x_n : normalised chord position ∈ [0, 1]  (0 = LE, 1 = TE)
// t   : max-thickness ratio (e.g. 0.20 → 20 % chord)
function naca_yt(x_n, t) =
    5 * t * (  0.2969 * sqrt(x_n)
             - 0.1260 * pow(x_n, 1)
             - 0.3516 * pow(x_n, 2)
             + 0.2843 * pow(x_n, 3)
             - 0.1015 * pow(x_n, 4) );

// NACA 4-series mean camber line (result is a fraction of chord).
// m : max camber ratio  (e.g. 0.04 → 4 % chord; 0 = symmetric)
// p : chord position of max camber (e.g. 0.40 → 40 % chord)
function naca_yc(x_n, m, p) =
    (x_n <= p)
    ? (m / (p*p)) * (2*p*x_n - x_n*x_n)
    : (m / ((1-p)*(1-p))) * ((1 - 2*p) + 2*p*x_n - x_n*x_n);

// Derivative of the mean camber line (dy_c / dx_n).
function naca_dyc(x_n, m, p) =
    (x_n <= p)
    ? (2*m / (p*p)) * (p - x_n)
    : (2*m / ((1-p)*(1-p))) * (p - x_n);


// 2D aerofoil polygon. Upper surface: LE → TE; lower surface: TE → LE.
// Surface points are offset from the camber line along its local normal,
// so the profile is correct for any non-zero camber.
// Set camber = 0 for a fully symmetric (NACA 00xx) profile.
// Cosine sampling concentrates points near LE and TE for better accuracy.
module aerofoil_2d(chord, thickness_ratio, camber, camber_pos, n_points) {
    upper = [for (i = [0 : n_points])
                 let (x_n   = (1 - cos(180 * i / n_points)) / 2,
                      yt    = naca_yt(x_n, thickness_ratio),
                      yc    = naca_yc(x_n, camber, camber_pos),
                      theta = atan(naca_dyc(x_n, camber, camber_pos)))
                 [(x_n - yt * sin(theta)) * chord,
                  (yc  + yt * cos(theta)) * chord]];
    lower = [for (i = [n_points : -1 : 0])
                 let (x_n   = (1 - cos(180 * i / n_points)) / 2,
                      yt    = naca_yt(x_n, thickness_ratio),
                      yc    = naca_yc(x_n, camber, camber_pos),
                      theta = atan(naca_dyc(x_n, camber, camber_pos)))
                 [(x_n + yt * sin(theta)) * chord,
                  (yc  - yt * cos(theta)) * chord]];
    polygon(concat(upper, lower));
}


// ============================================================================
// WING_AEROFOIL_SEGMENT — primary module
// ============================================================================
// Default parameters validated for a 50 mm spar_spacing blue_edge_hub spar
// with hub_cube_width=20, giving spar_size ≈ 58.28 mm:
//   chord=300, thickness_ratio=0.22 gives ≥ 0.5 mm clearance around the
//   inner box (spar_size/2 + inner_skin_thickness) at both spar faces.
// ============================================================================
module wing_aerofoil_segment(
    chord                = 300,   // total chord length (mm)
    span                 = 100,   // spanwise length of segment, along Z (mm)
    thickness_ratio      = 0.22,  // NACA max-thickness / chord
    camber               = 0.04,  // max camber as fraction of chord (0 = symmetric)
    camber_pos           = 0.40,  // chord position of max camber (fraction)
    skin_thickness       = 0.5,   // outer aerofoil shell wall thickness (mm)
    inner_skin_thickness = 1.2,   // inner spar-box wall thickness (mm)
    spar_spacing         = 50,    // hub centre-to-centre distance (mm)
    hub_cube_width       = 20,    // blue_edge_hub cube_width parameter
    le_fraction          = 0.25,  // chord fraction from LE to spar front face
    n_points             = 50     // profile sample points per surface half
) {
    // Spar void size: hub c-t-c plus the chamfer-cut overhang on each side.
    spar_size   = spar_spacing + hub_cube_width * (sqrt(2) - 1);

    le_x        = le_fraction * chord;
    // Centre the spar box on the camber line at the spar mid-chord so it
    // sits naturally inside the profile regardless of camber setting.
    spar_mid_xn = le_fraction + spar_size / (2 * chord);
    spar_y_ctr  = naca_yc(spar_mid_xn, camber, camber_pos) * chord;
    spar_y_lo   = spar_y_ctr - spar_size / 2;

    // ------------------------------------------------------------------
    // 1.  Outer aerofoil skin — thin shell, full span.
    // ------------------------------------------------------------------
    linear_extrude(span)
    difference() {
        aerofoil_2d(chord, thickness_ratio, camber, camber_pos, n_points);
        offset(r = -skin_thickness)
        aerofoil_2d(chord, thickness_ratio, camber, camber_pos, n_points);
    }

    // ------------------------------------------------------------------
    // 2.  Inner box skin — square tube enclosing the spar void, full span.
    //     Wall of inner_skin_thickness added outward from the spar void.
    // ------------------------------------------------------------------
    linear_extrude(span)
    difference() {
        translate([le_x - inner_skin_thickness,
                   spar_y_lo - inner_skin_thickness])
        square([spar_size + 2 * inner_skin_thickness,
                spar_size + 2 * inner_skin_thickness]);

        translate([le_x, spar_y_lo])
        square([spar_size, spar_size]);
    }
}
