// Gears Library — English wrapper for Getriebe.scad
//
// Provides English-named module wrappers around Dr Jörg Janssen's
// German-language gear library (Getriebe.scad).
//
// Original:  Getriebe.scad v2.3, 29 October 2018
// Author:    Dr Jörg Janssen
// License:   Creative Commons — Attribution, Non Commercial, Share Alike
// ============================================================================

include <Getriebe Bibliothek für OpenSCAD _ Gears Library for OpenSCAD - 1604369/files/Getriebe.scad>

// ═════════════════════════════════════════════════════════════════
// Parameter name map (German → English)
//
//   modul              → module_size     (DIN 780 gear module)
//   zahnzahl           → tooth_number
//   breite             → width
//   bohrung            → bore
//   eingriffswinkel    → pressure_angle
//   schraegungswinkel  → helix_angle
//   laenge             → length
//   hoehe              → height
//   randbreite         → rim_width
//   gangzahl           → thread_starts
//   steigungswinkel    → lead_angle
//   teilkegelwinkel    → pitch_cone_angle
//   zahnbreite         → face_width
//   achsenwinkel       → shaft_angle
//   zusammen_gebaut    → assembled
//   optimiert          → optimized
//   laenge_stange      → rack_length
//   hoehe_stange       → rack_height
//   zahnzahl_rad       → gear_teeth
//   zahnzahl_ritzel    → pinion_teeth
//   bohrung_rad        → gear_bore
//   bohrung_ritzel     → pinion_bore
//   zahnzahl_sonne     → sun_teeth
//   zahnzahl_planet    → planet_teeth
//   anzahl_planeten    → planet_count
//   bohrung_schnecke   → worm_bore
// ═════════════════════════════════════════════════════════════════


// ── Spur gear ──────────────────────────────────────────
//   stirnrad(modul, zahnzahl, breite, bohrung, eingriffswinkel, schraegungswinkel, optimiert)

module spur_gear(
    module_size    = 1,
    tooth_number   = 10,
    width          = 10,
    bore           = 3,
    pressure_angle = 20,
    helix_angle    = 0,
    optimized      = true
) {
    stirnrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        breite            = width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        optimiert         = optimized
    );
}


// ── Herringbone gear ───────────────────────────────────
//   pfeilrad(modul, zahnzahl, breite, bohrung, eingriffswinkel, schraegungswinkel, optimiert)

module herringbone_gear(
    module_size    = 1,
    tooth_number   = 10,
    width          = 10,
    bore           = 3,
    pressure_angle = 20,
    helix_angle    = 0,
    optimized      = true
) {
    pfeilrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        breite            = width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        optimiert         = optimized
    );
}


// ── Rack ───────────────────────────────────────────────
//   zahnstange(modul, laenge, hoehe, breite, eingriffswinkel, schraegungswinkel)

module rack(
    module_size    = 1,
    length         = 50,
    height         = 10,
    width          = 10,
    pressure_angle = 20,
    helix_angle    = 0
) {
    zahnstange(
        modul             = module_size,
        laenge            = length,
        hoehe             = height,
        breite            = width,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Rack and gear (assembled pair) ─────────────────────
//   zahnstange_und_rad(modul, laenge_stange, zahnzahl_rad, hoehe_stange,
//                      bohrung_rad, breite, eingriffswinkel, schraegungswinkel,
//                      zusammen_gebaut, optimiert)

module rack_and_gear(
    module_size    = 1,
    rack_length    = 50,
    gear_teeth     = 10,
    rack_height    = 10,
    gear_bore      = 3,
    width          = 10,
    pressure_angle = 20,
    helix_angle    = 0,
    assembled      = true,
    optimized      = true
) {
    zahnstange_und_rad(
        modul             = module_size,
        laenge_stange     = rack_length,
        zahnzahl_rad      = gear_teeth,
        hoehe_stange      = rack_height,
        bohrung_rad       = gear_bore,
        breite            = width,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        zusammen_gebaut   = assembled,
        optimiert         = optimized
    );
}


// ── Internal / ring gear ───────────────────────────────
//   hohlrad(modul, zahnzahl, breite, randbreite, eingriffswinkel, schraegungswinkel)

module internal_gear(
    module_size    = 1,
    tooth_number   = 30,
    width          = 10,
    rim_width      = 5,
    pressure_angle = 20,
    helix_angle    = 0
) {
    hohlrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        breite            = width,
        randbreite        = rim_width,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Herringbone internal gear ──────────────────────────
//   pfeilhohlrad(modul, zahnzahl, breite, randbreite, eingriffswinkel, schraegungswinkel)

module herringbone_internal_gear(
    module_size    = 1,
    tooth_number   = 30,
    width          = 10,
    rim_width      = 5,
    pressure_angle = 20,
    helix_angle    = 0
) {
    pfeilhohlrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        breite            = width,
        randbreite        = rim_width,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Planetary gearbox ──────────────────────────────────
//   planetengetriebe(modul, zahnzahl_sonne, zahnzahl_planet, anzahl_planeten,
//                    breite, randbreite, bohrung, eingriffswinkel,
//                    schraegungswinkel, zusammen_gebaut, optimiert)

module planetary_gearbox(
    module_size    = 1,
    sun_teeth      = 10,
    planet_teeth   = 10,
    planet_count   = 3,
    width          = 10,
    rim_width      = 5,
    bore           = 3,
    pressure_angle = 20,
    helix_angle    = 0,
    assembled      = true,
    optimized      = true
) {
    planetengetriebe(
        modul             = module_size,
        zahnzahl_sonne    = sun_teeth,
        zahnzahl_planet   = planet_teeth,
        anzahl_planeten   = planet_count,
        breite            = width,
        randbreite        = rim_width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        zusammen_gebaut   = assembled,
        optimiert         = optimized
    );
}


// ── Bevel gear ─────────────────────────────────────────
//   kegelrad(modul, zahnzahl, teilkegelwinkel, zahnbreite, bohrung,
//            eingriffswinkel, schraegungswinkel)

module bevel_gear(
    module_size      = 1,
    tooth_number     = 10,
    pitch_cone_angle = 45,
    face_width       = 10,
    bore             = 3,
    pressure_angle   = 20,
    helix_angle      = 0
) {
    kegelrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        teilkegelwinkel   = pitch_cone_angle,
        zahnbreite        = face_width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Herringbone bevel gear ─────────────────────────────
//   pfeilkegelrad(modul, zahnzahl, teilkegelwinkel, zahnbreite, bohrung,
//                 eingriffswinkel, schraegungswinkel)

module herringbone_bevel_gear(
    module_size      = 1,
    tooth_number     = 10,
    pitch_cone_angle = 45,
    face_width       = 10,
    bore             = 3,
    pressure_angle   = 20,
    helix_angle      = 0
) {
    pfeilkegelrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        teilkegelwinkel   = pitch_cone_angle,
        zahnbreite        = face_width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Spiral bevel gear ──────────────────────────────────
//   spiralkegelrad(modul, zahnzahl, teilkegelwinkel, zahnbreite, bohrung,
//                  eingriffswinkel, schraegungswinkel)

module spiral_bevel_gear(
    module_size      = 1,
    tooth_number     = 10,
    pitch_cone_angle = 45,
    face_width       = 10,
    bore             = 3,
    pressure_angle   = 20,
    helix_angle      = 30
) {
    spiralkegelrad(
        modul             = module_size,
        zahnzahl          = tooth_number,
        teilkegelwinkel   = pitch_cone_angle,
        zahnbreite        = face_width,
        bohrung           = bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle
    );
}


// ── Bevel gear pair ────────────────────────────────────
//   kegelradpaar(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel,
//                zahnbreite, bohrung_rad, bohrung_ritzel, eingriffswinkel,
//                schraegungswinkel, zusammen_gebaut)

module bevel_gear_pair(
    module_size    = 1,
    gear_teeth     = 20,
    pinion_teeth   = 10,
    shaft_angle    = 90,
    face_width     = 10,
    gear_bore      = 3,
    pinion_bore    = 3,
    pressure_angle = 20,
    helix_angle    = 0,
    assembled      = true
) {
    kegelradpaar(
        modul             = module_size,
        zahnzahl_rad      = gear_teeth,
        zahnzahl_ritzel   = pinion_teeth,
        achsenwinkel      = shaft_angle,
        zahnbreite        = face_width,
        bohrung_rad       = gear_bore,
        bohrung_ritzel    = pinion_bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        zusammen_gebaut   = assembled
    );
}


// ── Herringbone bevel gear pair ────────────────────────
//   pfeilkegelradpaar(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel,
//                     zahnbreite, bohrung_rad, bohrung_ritzel, eingriffswinkel,
//                     schraegungswinkel, zusammen_gebaut)

module herringbone_bevel_gear_pair(
    module_size    = 1,
    gear_teeth     = 20,
    pinion_teeth   = 10,
    shaft_angle    = 90,
    face_width     = 10,
    gear_bore      = 3,
    pinion_bore    = 3,
    pressure_angle = 20,
    helix_angle    = 10,
    assembled      = true
) {
    pfeilkegelradpaar(
        modul             = module_size,
        zahnzahl_rad      = gear_teeth,
        zahnzahl_ritzel   = pinion_teeth,
        achsenwinkel      = shaft_angle,
        zahnbreite        = face_width,
        bohrung_rad       = gear_bore,
        bohrung_ritzel    = pinion_bore,
        eingriffswinkel   = pressure_angle,
        schraegungswinkel = helix_angle,
        zusammen_gebaut   = assembled
    );
}


// ── Worm ───────────────────────────────────────────────
//   schnecke(modul, gangzahl, laenge, bohrung, eingriffswinkel,
//            steigungswinkel, zusammen_gebaut)

module worm(
    module_size    = 1,
    thread_starts  = 1,
    length         = 30,
    bore           = 3,
    pressure_angle = 20,
    lead_angle     = 10,
    assembled      = true
) {
    schnecke(
        modul           = module_size,
        gangzahl        = thread_starts,
        laenge          = length,
        bohrung         = bore,
        eingriffswinkel = pressure_angle,
        steigungswinkel = lead_angle,
        zusammen_gebaut = assembled
    );
}


// ── Worm gear set ──────────────────────────────────────
//   schneckenradsatz(modul, zahnzahl, gangzahl, breite, laenge,
//                    bohrung_schnecke, bohrung_rad, eingriffswinkel,
//                    steigungswinkel, optimiert, zusammen_gebaut)

module worm_gear_set(
    module_size    = 1,
    tooth_number   = 20,
    thread_starts  = 1,
    width          = 10,
    length         = 30,
    worm_bore      = 3,
    gear_bore      = 3,
    pressure_angle = 20,
    lead_angle     = 10,
    optimized      = true,
    assembled      = true
) {
    schneckenradsatz(
        modul             = module_size,
        zahnzahl          = tooth_number,
        gangzahl          = thread_starts,
        breite            = width,
        laenge            = length,
        bohrung_schnecke  = worm_bore,
        bohrung_rad       = gear_bore,
        eingriffswinkel   = pressure_angle,
        steigungswinkel   = lead_angle,
        optimiert         = optimized,
        zusammen_gebaut   = assembled
    );
}
