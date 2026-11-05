// Dragonfly: NASA's rotorcraft lander for Titan, as being built in 2026, built from
// spacecraft_details/dimensions.md. The rotors, HGA, MMRTG and landing gear come from their own files.
// Units are mm at full size, Z up, with the skid bottoms on z = 0. +X points to the nose, +Y to the
// lander's left, and x = 0 is halfway between the front and rear rotor axes.
// Values under [From dimensions.md] come from that file, which tags each one Published, Measured or
// Estimated; the comments mark the estimated ones. Values under [Estimates] aren't in dimensions.md, so
// they are guesses worth adjusting.

use <rotor.scad>
use <hga.scad>
use <mmrtg.scad>
use <skid.scad>

/* [Print] */
// Print at 1:model_scale. 1 is full size; 24 makes the lander about 170 mm long.
model_scale = 1; // [1:1000]
// The thinnest part allowed on the print, in mm at print size: blades and rods are thickened to at least
// this. 0 keeps them true to size.
min_feature = 0; // [0:0.1:3]

/* [Configuration] */
// Draws the foam and what mounts on it. Off shows the bare aluminium fuselage as it was in mid-2026.
show_foam = true;
// The foam's finish, which isn't published. 1: the wrinkled champagne-silver metallised skin of NASA's
// renderings; 2: the glossy orange polyimide film of the insulation test section.
foam_finish = 2; // [1:Metallised, 2:Orange film]
// HGA's elevation: 0 is stowed flat; 70 is as in NASA's landed renderings.
hga_elevation = 70; // [0:90]
// Blade angles of each rotor, so the pairs don't all look alike
rotor_phase = 25; // [0:120]

/* [From dimensions.md] */
// Rotor axes (x estimated from the June 1 photo; y from the published width and rotor diameter)
axis_x = 868;
axis_y = 1250;
// Arm's axis height (estimated)
arm_z = 854;
// Arm tube's diameter at the root and at the hub (estimated)
arm_d = [110, 85];
// Foam thickness
foam = 76;
// The box, from the June 1 photo (estimated): belly, deck, and its ends
box_belly = 430;
box_depth = 547;
box_rear_bottom = -1425;
box_rear_top = -1179;
box_front = 1849;
// How far back from the front the belly starts to rise, and how much
box_front_chamfer = [283, 57];
// Box's width: the print model's less the foam
box_width = 830;
// Where the hood's rear wall sits
hood_rear = 981;
// MMRTG's axis above horizontal
mmrtg_tilt = 24;
// Fairing over each arm root: half-length along x, its reach out from the centreline, and its bottom z
fairing = [210, 565, 760];
// HGA's mount (x from the print model, stretched; estimated)
hga_x = 179;

/* [Estimates] */
// Foam sleeve on each arm: its diameter and its reach beyond the fairing
sleeve = [210, 160];

/* [Hidden] */
$fn = 32;
foam_deck = box_belly + box_depth + foam;
foam_belly = box_belly - foam;
// The hull's stations, front to back: [x, belly z, top z, half-width, corner radius]. The hood is
// measured from the print model, stretched along x; the rest is the box plus the foam.
hull_sections = [
    [box_front + foam, 730, 860, 300, 40], [1894, 651, 925, 364, 65], [1833, 547, 1055, 385, 80],
    [1752, 509, 1178, 403, 100], [1695, 495, 1240, 442, 118], [1630, 482, 1296, 475, 130],
    [1530, 465, 1358, 483, 133], [1427, 449, 1403, 487, 133], [1320, 425, 1431, 487, 128],
    [1224, 400, 1446, 487, 122], [1062, 360, 1454, 487, 113], [1010, foam_belly, 1440, 487, 100],
    [hood_rear + 4, foam_belly, 1400, 487, 90], [hood_rear - 20, foam_belly, foam_deck, 490, 40],
    [box_rear_top - foam * 0.91, foam_belly, foam_deck, 490, 40],
    [box_rear_bottom - foam * 0.91, foam_belly, foam_belly + 18, 470, 8]];
// The hood's roof sheet: its lower edge in the xz plane, then round the top
roof_edge = [[hood_rear - 6, 1230], [1300, 1240], [1560, 1160], [1740, 1000], [1850, 850], [1960, 800], [2000, 1500], [hood_rear - 6, 1500]];
// Tail fin's outline, [x, z], measured from the print model and moved forward with the deck's end
fin_shift = 100;
fin_outline = [
    [-1733, 450], [-2118, 587], [-2209, 784], [-2210, 817], [-1969, 1377], [-1508, 1574], [-1446, 1579],
    [-1400, 1551], [-1378, 1497], [-1379, 1079], [-1709, 464]];
fin_y = 380;   // the fin's front edge from the centreline
fin_splay = 13.4;
fin_t = 36;

// Colours
foam_metal = [0.75, 0.71, 0.63];
foam_film = [0.88, 0.42, 0.08];
foam_colour = foam_finish == 1 ? foam_metal : foam_film;
panel_colour = foam_finish == 1 ? [0.67, 0.63, 0.56] : [0.82, 0.37, 0.06];
roof_colour = foam_finish == 1 ? [0.58, 0.54, 0.47] : [0.8, 0.36, 0.05];
box_colour = [0.6, 0.61, 0.64];
belly_colour = [0.83, 0.74, 0.48];
tape = [0.9, 0.7, 0.1];
fin_colour = [0.66, 0.5, 0.2];
arm_silver = [0.74, 0.75, 0.77];
block_grey = [0.45, 0.45, 0.47];
copper = [0.72, 0.5, 0.32];
dark = [0.07, 0.07, 0.09];
gold = [0.8, 0.65, 0.3];
pot = [0.78, 0.78, 0.8];
rod = [0.7, 0.71, 0.73];

// Connector windows on the bare box's sides, [x, z], from the June 1 photo
box_windows = [[-1120, 790], [-620, 700], [-180, 700], [1100, 700], [1660, 730]];

// One hull station: a rounded rectangle in the yz plane at its x
module station(s, grow = 0) {
    translate([s[0] + grow, 0, 0]) rotate([90, 0, 90]) linear_extrude(0.5) offset(delta = grow)
        hull() for (y = [-1, 1], z = [s[1], s[2]]) {
            r = min(s[4], (s[2] - s[1]) / 2 - 0.1);
            translate([y * (s[3] - r), z == s[1] ? z + min(r, 40) : z - r]) circle(r = z == s[1] ? min(r, 40) : r, $fn = 24);
        }
}

module foam_hull(grow = 0) {
    n = len(hull_sections);
    for (i = [0:n - 2]) hull() {
        station(hull_sections[i], grow);
        station(hull_sections[i + 1], grow);
    }
}

// The hood's roof, a separate sheet in NASA's renderings: the hull, grown a little, above roof_edge
module hood_roof() {
    color(roof_colour) intersection() {
        foam_hull(5);
        rotate([90, 0, 0]) linear_extrude(1400, center = true) polygon(roof_edge);
    }
}

// Fairing over an arm's root, at its x, on the left
module arm_fairing(x) {
    color(foam_colour) hull() {
        translate([x - fairing[0], 400, fairing[2]]) cube([2 * fairing[0], 40, foam_deck - fairing[2]]);
        translate([x - fairing[0] + 30, fairing[1] - 2, fairing[2] + 35]) cube([2 * fairing[0] - 60, 2, foam_deck - fairing[2] - 90]);
    }
    // The foam sleeve round the arm
    color(foam_colour) translate([x, fairing[1], arm_z]) rotate([-90, 0, 0]) {
        cylinder(d = sleeve[0], h = sleeve[1]);
        color(panel_colour) cylinder(d = sleeve[0] + 22, h = 14);
        color(panel_colour) translate([0, 0, sleeve[1] - 10]) cylinder(d = sleeve[0] + 14, h = 10);
    }
}

// Raised panels and detail on the hull's left side
module hull_side() {
    // Raised panels mid-body: rounded rectangles standing proud of the foam
    color(panel_colour) for (p = [[-470, 460, 490, 800], [-470, 330, 840, 1000], [-190, 760, 450, 720]])
        translate([p[0], 480, p[2]]) rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(50)
            offset(r = 22) offset(delta = -22) square([p[1], p[3] - p[2]]);
    // Two dark slots high on the hood's side, with pipes running down to a canned fan
    color(dark) for (x = [1180, 1530]) translate([x, 486, 1080]) cube([70, 6, 30]);
    // Pipes
    for (path = duct_path) color(copper) for (i = [0:len(path) - 2]) hull() {
        translate(path[i]) sphere(d = 22, $fn = 10);
        translate(path[i + 1]) sphere(d = 22, $fn = 10);
    }
    // Canned fan
    color(pot) translate(fan_can) cylinder(d = 150, h = 170, $fn = 30);
    color(block_grey) translate(fan_can + [0, 0, 170]) cylinder(d = 165, h = 16, $fn = 30);
}
// The ducting: pairs of pipes down from the slots to the fan, and on along the lower side
fan_can = [1090, 545, 660];
duct_path = [
    [[1215, 494, 1080], [1215, 514, 980], [1215, 530, 780], [1120, 540, 700]],
    [[1565, 494, 1080], [1500, 512, 950], [1400, 526, 760], [1300, 540, 640], [1120, 545, 650]],
    [[1090, 545, 660], [1020, 530, 590], [800, 505, 545], [360, 505, 520], [150, 505, 520]],
    [[1040, 540, 620], [820, 515, 510], [360, 515, 480], [100, 515, 480]]];

// A camera housing with its base on the surface at p, looking along n
module camera(p, n, size = 130) {
    a = atan2(n[1], n[0]);
    e = atan2(n[2], norm([n[0], n[1]]));
    translate(p) rotate([0, 0, a]) rotate([0, 90 - e, 0]) {
        rotate([0, 0, 45]) {
            color(gold) cylinder(d1 = size * 1.7, d2 = size * 1.25, h = 80, $fn = 4);
            color(dark) translate([0, 0, 78]) cylinder(d = size, h = 4, $fn = 4);
        }
    }
}

// Things on the left half of the nose
module nose_left() {
    camera([1640, 470, 740], [0.35, 0.93, -0.1]);
    camera([1840, 310, 1020], [0.8, 0.5, 0.33]);
    camera([1855, 285, 640], [0.85, 0.42, -0.3]);
}

// E-field rod from a to b with a ball on b's end
module rod_at(a, b) {
    d = max(26, min_feature * model_scale);
    color(rod) hull() {
        translate(a) sphere(d = d * 1.4, $fn = 12);
        translate(b) sphere(d = d * 0.8, $fn = 12);
    }
    color(rod) translate(b) sphere(d = max(54, min_feature * model_scale), $fn = 16);
}

// Things on the deck: the rear pots, MGA and LGA, and a small mid-deck mount
module deck_kit() {
    for (s = [1, -1]) translate([-880, s * 220, foam_deck]) {
        color(pot) cylinder(d = 228, h = 155, $fn = 36);
        color(block_grey) translate([0, 0, 155]) cylinder(d = 100, h = 130, $fn = 24);
        color(s > 0 ? dark : pot) translate([0, 0, 285]) cylinder(d = s > 0 ? 316 : 180, h = 34, $fn = 40);
    }
    // Mid-deck pyramid on a plate
    translate([-300, 0, foam_deck]) {
        color(gold) translate([-120, -120, 0]) cube([240, 240, 16]);
        color(pot) cylinder(d1 = 160, d2 = 40, h = 110, $fn = 4);
    }
    // HGA launch lock under the dish's far edge when stowed
    translate([hga_x - 860, 0, foam_deck]) {
        color(block_grey) translate([-40, -60, 0]) cube([80, 120, 130]);
        color(gold) translate([0, 0, 130]) cylinder(d = 50, h = 26, $fn = 18);
    }
}

// Bare box's outline in the xz plane
function box_outline() = [
    [box_rear_bottom, box_belly], [box_front - box_front_chamfer[0], box_belly],
    [box_front, box_belly + box_front_chamfer[1]], [box_front, box_belly + box_depth],
    [box_rear_top, box_belly + box_depth]];

module box_extrude(w) {
    rotate([90, 0, 0]) linear_extrude(w, center = true) children();
}

// The bare aluminium box, with gold tape along the side panels' edges and pale gold belly and rear wall
module bare_box() {
    color(box_colour) box_extrude(box_width) polygon(box_outline());
    color(belly_colour) box_extrude(box_width - 6) translate([0, -2]) polygon([
        [box_rear_bottom + 5, box_belly], [box_front - box_front_chamfer[0], box_belly],
        [box_front, box_belly + box_front_chamfer[1]], [box_front, box_belly + box_front_chamfer[1] + 6],
        [box_rear_bottom + 5, box_belly + 6]]);
    // Tape round each side, and connector windows: thin layers on the side panels
    for (s = [1, -1]) translate([0, s * (box_width / 2 + 1), 0]) {
        color(tape) box_extrude(2) difference() {
            polygon(box_outline());
            offset(delta = -28) polygon(box_outline());
        }
        for (p = box_windows) {
            color(gold) translate([0, s, 0]) box_extrude(2) translate(p) square([150, 90], center = true);
            color(pot) translate([0, 2 * s, 0]) box_extrude(2) translate(p) square([110, 56], center = true);
        }
    }
}

// The outside of the fuselage
module hull_all() {
    if (show_foam) {
        color(foam_colour) foam_hull();
        hood_roof();
        for (s = [1, -1]) mirror([0, s < 0 ? 1 : 0, 0]) {
            for (x = [axis_x, -axis_x]) arm_fairing(x);
            hull_side();
            nose_left();
        }
    } else {
        bare_box();
    }
}

// A tail fin on the left, as a thin plate splayed out to the rear
module fin() {
    color(fin_colour) translate([box_rear_top + foam * 0.2, fin_y, 0]) rotate([0, 0, fin_splay])
        translate([-(box_rear_top + foam * 0.2), 0, 0]) rotate([90, 0, 0]) linear_extrude(fin_t, center = true)
            translate([fin_shift, 0]) polygon(fin_outline);
}

// An arm on the left, from the fuselage out to the rotor axis at x, with the pair of rotors
module arm_left(x, phases) {
    root = box_width / 2;
    // Bolted block on the side of the box
    color(block_grey) translate([x, root + 50, arm_z]) cube([190, 100, 170], center = true);
    color(arm_silver) translate([x, root, arm_z]) rotate([-90, 0, 0]) {
        translate([0, 0, 100]) cylinder(d = 150, h = 26, $fn = 36);
        cylinder(d1 = arm_d[0], d2 = arm_d[1], h = axis_y - root - 60, $fn = 28);
    }
    translate([x, axis_y, arm_z]) rotor_pair(phases = phases, thin = min_feature * model_scale);
}

// The lander's left side: everything mirrored for the right
module left_side_parts() {
    gear_left();
    fin();
}

scale(1 / model_scale) {
    hull_all();
    for (s = [1, -1]) mirror([0, s < 0 ? 1 : 0, 0]) left_side_parts();
    arm_left(axis_x, [rotor_phase, rotor_phase + 60]);
    arm_left(-axis_x, [rotor_phase + 40, rotor_phase + 100]);
    mirror([0, 1, 0]) {
        arm_left(axis_x, [rotor_phase + 80, rotor_phase + 20]);
        arm_left(-axis_x, [rotor_phase + 15, rotor_phase + 75]);
    }
    // MMRTG at the rear wall, square to it
    let(deck = box_belly + box_depth, mid = (box_belly + deck) / 2, xmid = (box_rear_bottom + box_rear_top) / 2)
        translate([xmid - 0.91 * (show_foam ? foam : 0), 0, mid + 0.41 * (show_foam ? foam : 0)])
            rotate([0, -(90 - mmrtg_tilt), 0]) mmrtg();
    // HGA on the deck
    translate([hga_x, 0, show_foam ? foam_deck : box_belly + box_depth]) hga(hga_elevation);
    if (show_foam) {
        deck_kit();
        // E-field rods: one up on the nose, one at the rear
        rod_at([1650, -360, 1190], [1860, -560, 1420]);
        rod_at([-1100, 480, 420], [-1420, 700, 340]);
    }
}
