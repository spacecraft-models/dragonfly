// Dragonfly's high-gain antenna: a flat radial line slot dish on a truss pyramid and gimbal block, for
// model/dragonfly.scad to pull in with use <hga.scad>. Rendered on its own, this file shows it raised.
// Units are mm, Z up, with the mount's foot on z = 0, its centre on the Z axis, and the dish stowing
// towards -X. Sizes and finish come from spacecraft_details/dimensions.md, "High-gain antenna", and
// the May 14, 2026 and antenna chamber photos in source_data.md.

/* [Print] */
// Print at 1:model_scale. 1 is full size.
model_scale = 1; // [1:1000]
// Elevation of the dish: 0 is stowed flat, face up; 70 is as in NASA's landed renderings.
elevation = 70; // [0:90]
// Draws the dish's slots and centre pads. These only draw in previews and PNGs, not in the STL.
slots = true;

/* [From dimensions.md] */
dish_d = 874;
// Thickness of the dish (estimated)
dish_t = 25;
// Across the mount's foot on the deck
mount_d = 483;
// Height of the axle above the deck (estimated)
axle_h = 180;
// Rings of right-angled slot pairs, how far apart, and the slot lengths at the centre and the rim (estimated)
slot_rings = 12;
ring_pitch = 30;
slot_len = [11, 27];

/* [Hidden] */
face = [0.94, 0.64, 0.17];
rim = [0.87, 0.68, 0.14];
back = [0.72, 0.45, 0.26];
slot_dark = [0.62, 0.36, 0.07];
pad = [0.55, 0.32, 0.1];
truss = [0.2, 0.2, 0.22];
block = [0.56, 0.56, 0.58];
gold = [0.8, 0.65, 0.3];

// Dish, centred on its axis, with its face on z = 0 looking +Z
module dish(show_slots = slots) {
    color(face) translate([0, 0, -2]) cylinder(d = dish_d - 8, h = 2, $fn = 128);
    color(rim) translate([0, 0, -dish_t + 8]) cylinder(d = dish_d, h = dish_t - 10, $fn = 128);
    color(back) translate([0, 0, -dish_t]) cylinder(d = dish_d - 6, h = 8, $fn = 128);
    if (show_slots && $preview) {
        for (i = [1:slot_rings]) {
            r = 70 + (i - 1) * ring_pitch;
            len = slot_len[0] + (slot_len[1] - slot_len[0]) * (i - 1) / (slot_rings - 1);
            n = floor(2 * PI * r / (len * 1.5 + 42));
            for (k = [0:n - 1]) rotate([0, 0, k * 360 / n + i * 11]) translate([r, 0, 0]) {
                color(slot_dark) rotate([0, 0, 45]) translate([0, -2, 0]) cube([len, 4, 0.8]);
                color(slot_dark) rotate([0, 0, -45]) translate([0, -2, 0]) cube([len, 4, 0.8]);
            }
        }
        // Six pads round the centre
        for (k = [0:5]) color(pad) rotate([0, 0, k * 60]) translate([45, 0, 0]) cylinder(d = 26, h = 1, $fn = 20);
    }
}

// A truss leg between two points, as a thin tube
module strut(a, b, d = 16) {
    hull() {
        translate(a) sphere(d = d, $fn = 10);
        translate(b) sphere(d = d, $fn = 10);
    }
}

// Mount: a ring on the deck, a truss pyramid and a gimbal block with the axle along Y at z = axle_h
module mount() {
    n = 6;
    color(truss) {
        cylinder(d = mount_d, h = 14, $fn = 64);
        for (i = [0:n - 1]) let(a = i * 360 / n, b = (i + 1) * 360 / n, r = mount_d / 2 - 15) {
            strut([r * cos(a), r * sin(a), 8], [60 * cos(a + 30), 60 * sin(a + 30), axle_h - 60], 26);
            strut([r * cos(b), r * sin(b), 8], [60 * cos(a + 30), 60 * sin(a + 30), axle_h - 60], 26);
        }
    }
    color(block) {
        translate([0, 0, axle_h - 60]) cylinder(d = 150, h = 22, $fn = 36);
        translate([-45, -60, axle_h - 42]) cube([90, 120, 80]);
    }
    color(gold) translate([0, 0, axle_h]) rotate([90, 0, 0]) cylinder(d = 46, h = 170, center = true, $fn = 24);
}

// The dish on its two arms, pivoted on the axle (at the origin here). Stowed, it lies towards -X.
module dish_on_arms() {
    gap = 60;     // axle to the dish's rim
    drop = 42;    // how far above the axle the dish's back lies when stowed
    cx = -(gap + dish_d / 2);
    translate([cx, 0, drop + dish_t]) dish();
    // Two arms from the axle to the dish's back
    color(block) for (y = [-65, 65]) hull() {
        translate([0, y, 0]) rotate([90, 0, 0]) cylinder(d = 42, h = 12, center = true, $fn = 20);
        translate([cx * 0.75, y * 1.9, drop - 6]) cube([60, 12, 12], center = true);
    }
    // Ribs under the dish's middle
    color(back) translate([cx + 160, 0, drop - 4]) cube([360, 150, 10], center = true);
}

// The whole antenna at this elevation
module hga(el = elevation) {
    mount();
    translate([0, 0, axle_h]) rotate([0, el, 0]) dish_on_arms();
}

scale(1 / model_scale) hga();
