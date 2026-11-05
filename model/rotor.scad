// Dragonfly's rotors: one three-bladed fixed-pitch rotor and the hub stack that carries a coaxial pair,
// for model/dragonfly.scad to pull in with use <rotor.scad>. Rendered on its own, this file shows a pair
// on the end of a stub of arm.
// Units are mm, Z up, with the rotor's axis on the Z axis and the disc on z = 0. A blade's first station
// points along +X, with its chord along Y. Sizes come from spacecraft_details/dimensions.md, "Rotors and
// arms": the chord is measured from NASA's print model, and the root and tip shapes from the rotor test
// photo in source_data.md.

/* [Print] */
// Print at 1:model_scale. 1 is full size.
model_scale = 1; // [1:1000]
// The thinnest part allowed on the print, in mm at print size: the blades are thickened to at least this
min_feature = 0; // [0:0.1:3]

/* [From dimensions.md] */
rotor_d = 1350;
blades = 3;
// Blade pitch in degrees. Measured flat at 21.5 in the print model; real blades are surely twisted.
blade_pitch = 21.5;
// Tips out of plane in degrees, + towards the disc's opposite rotor in a pair. The print model has about
// 5; the photos don't settle it.
blade_cone = 0;
// Spacing of the two discs in a pair
disc_spacing = 340;
// Height of the upper disc above the arm's axis
upper_above_arm = 122;

/* [Hidden] */
// [radius, chord, thickness], mm, from root to tip
blade_table = [
    [90, 52, 22], [135, 96, 24], [200, 128, 20], [310, 124, 16], [420, 114, 14],
    [530, 102, 12], [620, 88, 10], [655, 66, 8], [675, 20, 5]];
// Bands near the tip, from the rotor test photo: from radius, to radius, white or not
tip_bands = [[540, 565, 1], [565, 590, 0], [590, 615, 1], [615, 640, 0], [640, 675, 1]];

carbon = [0.13, 0.13, 0.14];
band_white = [0.88, 0.88, 0.86];
hub_silver = [0.74, 0.75, 0.77];
hub_dark = [0.09, 0.09, 0.1];
hub_gold = [0.77, 0.62, 0.3];

// Interpolate blade_table at radius r
function blade_at(r) = [r, lookup(r, [for (s = blade_table) [s[0], s[1]]]),
                        lookup(r, [for (s = blade_table) [s[0], s[2]]])];

// One station of a blade: a thin airfoil-shaped slab at radius s[0]
module blade_station(s, pitch, cone, thin) {
    c = s[1];
    t = max(s[2], thin);
    translate([s[0], 0, s[0] * tan(cone)]) rotate([pitch, 0, 0]) rotate([0, 90, 0]) linear_extrude(0.5)
        polygon([[0, -c / 2], [-t * 0.6, -c * 0.3], [-t * 0.7, 0], [-t * 0.4, c * 0.35], [0, c / 2],
                 [t * 0.25, c * 0.3], [t * 0.3, 0], [t * 0.25, -c * 0.3]]);
}

// A blade along +X. Handed: `hand` of 1 or -1 gives the opposite pitch for the counter-rotating disc.
module blade(hand = 1, cone = blade_cone, thin = 0) {
    pitch = hand * blade_pitch;
    // Stations: the table's, plus the band edges
    rs = [for (s = blade_table) if (s[0] < tip_bands[0][0]) s[0]];
    inner = concat(rs, [tip_bands[0][0]]);
    color(carbon) for (i = [0:len(inner) - 2]) hull() {
        blade_station(blade_at(inner[i]), pitch, cone, thin);
        blade_station(blade_at(inner[i + 1]), pitch, cone, thin);
    }
    for (b = tip_bands) {
        stations = [for (s = blade_table) if (s[0] > b[0] && s[0] < b[1]) s[0]];
        edges = concat([b[0]], stations, [b[1]]);
        color(b[2] ? band_white : carbon) for (i = [0:len(edges) - 2]) hull() {
            blade_station(blade_at(edges[i]), pitch, cone, thin);
            blade_station(blade_at(edges[i + 1]), pitch, cone, thin);
        }
    }
}

// One rotor, disc on z = 0, with a dark root collar. `phase` is the first blade's angle.
module rotor(hand = 1, phase = 0, cone = blade_cone, thin = 0) {
    rotate([0, 0, phase]) for (i = [0:blades - 1]) rotate([0, 0, i * 360 / blades]) {
        blade(hand, cone, thin);
        color(hub_silver) translate([55, 0, 0]) rotate([0, 90, 0]) cylinder(d = 40, h = 45, $fn = 18);
    }
    color(hub_silver) cylinder(d = 130, h = 32, center = true, $fn = 36);
}

// The hub stack between two discs, with the arm's end on its side at z = 0, its axis along -Y.
// Upper disc at z = up, lower at z = -down.
module hub_stack(up, down) {
    color(hub_silver) translate([0, 0, -down]) cylinder(d = 90, h = up + down, $fn = 30);
    // A motor on each side of the arm
    for (z = [up - 95, -down + 95]) translate([0, 0, z]) {
        color(hub_silver) cylinder(d = 200, h = 130, center = true, $fn = 48);
        color(hub_dark) cylinder(d = 204, h = 44, center = true, $fn = 48);
        color(hub_gold) translate([0, 0, 68]) cylinder(d = 120, h = 8, center = true, $fn = 30);
    }
    // Block where the arm meets the stack
    color(hub_silver) hull() {
        cylinder(d = 110, h = 90, center = true, $fn = 30);
        translate([0, -70, 0]) rotate([90, 0, 0]) cylinder(d = 90, h = 2, $fn = 24);
    }
    // Dark caps above and below
    for (z = [up + 16, -down - 16]) color(hub_dark) translate([0, 0, z]) cylinder(d = 80, h = 22, center = true, $fn = 24);
}

// A coaxial pair round the arm's end. phases sets each disc's blade angle.
module rotor_pair(up = upper_above_arm, down = disc_spacing - upper_above_arm, phases = [0, 60], thin = 0,
                  cone = blade_cone) {
    hub_stack(up, down);
    translate([0, 0, up]) rotor(1, phases[0], -cone, thin);
    translate([0, 0, -down]) rotor(-1, phases[1], cone, thin);
}

scale(1 / model_scale) {
    rotor_pair(thin = min_feature * model_scale);
    color(hub_silver) rotate([90, 0, 0]) cylinder(d = 85, h = 400, $fn = 24);
}
