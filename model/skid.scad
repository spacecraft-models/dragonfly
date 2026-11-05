// Dragonfly's landing gear: a flat plate skid, two bent strip legs and a DrACO drill pack, for
// model/dragonfly.scad to pull in with use <skid.scad>. Rendered on its own, this file shows the left side.
// Units are mm, Z up, with the skid's bottom on z = 0, +X towards the nose and the lander's centreline on
// y = 0. Sizes come from spacecraft_details/dimensions.md, "Skids, legs and drills": the forms from the
// May 12, 2026 tap test photo, and the sizes from NASA's print model.

/* [Print] */
// Print at 1:model_scale. 1 is full size.
model_scale = 1; // [1:1000]
// Draws the DrACO drill pack
show_drill = true;

/* [From dimensions.md] */
// Centre to centre of the skids
track = 1466;
skid_width = 173;
// Skid's half-length, and the legs' x (estimated)
skid_half = 1217;
leg_x = 868;
// How far before the tip its bottom starts to rise, and the height of its tip's top
tip_rise = 303;
tip_top = 172;
// Skid plate's thickness
skid_t = 60;
// The leg's width along x
leg_width = 90;
// The drill pack's size: along x, across y, and its height
drill_pack = [243, 204, 657];
// Drill pack's position along the skid (estimated)
drill_x = 180;
// Height of the belly's underside where the leg meets it, from the hull
belly_z = 354;

/* [Hidden] */
skid_gold = [0.82, 0.73, 0.45];
leg_grey = [0.58, 0.58, 0.6];
gold = [0.8, 0.65, 0.3];
fork = [0.32, 0.32, 0.34];
pack = [0.48, 0.48, 0.5];
tube = [0.68, 0.69, 0.71];
// The leg's centreline in the yz plane, from the skid up and round to under the belly
leg_path = [[733, 40], [790, 150], [880, 360], [840, 460], [720, belly_z + 110], [500, belly_z + 55]];

// A skid centred on y = 0, along x
module skid() {
    color(skid_gold) rotate([90, 0, 0]) linear_extrude(skid_width, center = true)
        polygon([[-skid_half + tip_rise, 0], [skid_half - tip_rise, 0], [skid_half, tip_top - skid_t * 0.6],
                 [skid_half - 15, tip_top], [skid_half - tip_rise - 15, skid_t], [-skid_half + tip_rise + 15, skid_t],
                 [-skid_half + 15, tip_top], [-skid_half, tip_top - skid_t * 0.6]]);
}

// A bent strip leg in the yz plane at x = 0, widening towards the skid
module leg() {
    n = len(leg_path);
    color(leg_grey) for (i = [0:n - 2]) hull() {
        for (j = [i, i + 1]) let(w = leg_width * (1 + 0.5 * (n - 1 - j) / (n - 1)))
            translate([0, leg_path[j][0], leg_path[j][1]]) cube([w, 22 + 25 * (j / (n - 1)), 44], center = true);
    }
    // A foot on the skid and a fork under the belly
    color(gold) translate([0, 733, skid_t + 14]) cube([120, 90, 30], center = true);
    color(fork) translate([0, 455, belly_z + 25]) cube([130, 110, 60], center = true);
}

// The drill pack, standing on z = 0, centred on the origin: a block with two drill tubes on its outer side
module drill(size = drill_pack) {
    color(pack) translate([-size[0] / 2, -size[1] / 2, 0]) cube([size[0], size[1] * 0.55, size[2] * 0.72]);
    color(pack) translate([-size[0] / 2, -size[1] / 2, 0]) cube([size[0] * 1.0, size[1], size[2] * 0.14]);
    for (x = [-size[0] * 0.26, size[0] * 0.26]) translate([x, size[1] * 0.22, 0]) {
        color(tube) cylinder(d = 58, h = size[2] * 0.93, $fn = 18);
        color(fork) cylinder(d = 76, h = size[2] * 0.2, $fn = 18);
        color(gold) translate([0, 0, size[2] * 0.93]) cylinder(d = 76, h = size[2] * 0.07, $fn = 18);
    }
}

// All the gear on the lander's left (+Y). The right is its mirror image.
module gear_left(with_drill = show_drill) {
    translate([0, track / 2, 0]) skid();
    for (x = [-leg_x, leg_x]) translate([x, 0, 0]) leg();
    if (with_drill) translate([drill_x, track / 2 - 130, skid_t]) drill();
}

scale(1 / model_scale) gear_left();
