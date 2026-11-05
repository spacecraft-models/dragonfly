// Dragonfly's power source: the MMRTG in its ribbed can and fluted cap, for model/dragonfly.scad to pull
// in with use <mmrtg.scad>. Rendered on its own, this file shows it standing up.
// Units are mm, Z up, with the mounting face on z = 0, the axis on the Z axis and the cap's end on top.
// Sizes and finish come from spacecraft_details/dimensions.md, "MMRTG", from the June 1, 2026 photo.

/* [Print] */
// Print at 1:model_scale. 1 is full size.
model_scale = 1; // [1:1000]

/* [From dimensions.md] */
// Silver can's diameter and length, and the cap's (estimated)
can_d = 650;
can_len = 487;
cap_d = 560;
cap_len = 325;

/* [Hidden] */
silver = [0.8, 0.81, 0.83];
seam = [0.56, 0.57, 0.6];
cap_gold = [0.8, 0.72, 0.5];
dark = [0.25, 0.25, 0.27];
gold = [0.76, 0.6, 0.25];

// Length from the mounting face to the cap's end
function mmrtg_length() = can_len + cap_len;

module mmrtg() {
    // Mounting flange and ring into the fuselage's rear wall
    color(gold) cylinder(d = can_d - 30, h = 24, $fn = 96);
    // Ribbed silver can: rings and lengthwise seams
    color(silver) translate([0, 0, 24]) cylinder(d = can_d - 14, h = can_len - 24, $fn = 96);
    color(seam) for (z = [24, 150, 290, can_len - 20]) translate([0, 0, z]) cylinder(d = can_d, h = 12, $fn = 96);
    color(seam) for (a = [0:30:330]) rotate([0, 0, a]) translate([can_d / 2 - 12, -5, 24]) cube([12, 10, can_len - 40]);
    // Fluted cap: narrower, with ribs round it
    color(cap_gold) translate([0, 0, can_len]) cylinder(d = cap_d, h = cap_len - 40, $fn = 96);
    color(cap_gold) for (a = [0:7.5:352]) rotate([0, 0, a]) translate([cap_d / 2 - 4, -8, can_len + 30]) cube([12, 16, cap_len - 110]);
    color(seam) translate([0, 0, can_len]) cylinder(d = cap_d + 30, h = 20, $fn = 96);
    color(seam) translate([0, 0, can_len + cap_len - 50]) cylinder(d = cap_d + 12, h = 16, $fn = 96);
    // Stepped end with a dark centre
    color(cap_gold) translate([0, 0, can_len + cap_len - 40]) cylinder(d1 = cap_d, d2 = cap_d - 80, h = 40, $fn = 96);
    color(dark) translate([0, 0, can_len + cap_len - 2]) cylinder(d = cap_d - 160, h = 4, $fn = 64);
    // Ports on the side of the can
    color(seam) rotate([0, 0, 40]) translate([can_d / 2 - 10, 0, 330]) rotate([0, 90, 0]) cylinder(d = 150, h = 32, $fn = 30);
}

scale(1 / model_scale) mmrtg();
