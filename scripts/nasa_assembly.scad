// NASA's "Dragonfly LV" printable model, reassembled from its 14 STL files (git-ignored, in
// source_data/nasa_model/stl/) and scaled up to full size, as a reference to measure and to compare
// model/dragonfly.scad with. It is not part of the model. The STLs are laid out flat on a print plate,
// in metres; the transforms below put each part where the assembly guide says it goes.
// Units are mm at full size, Z up, with the skid bottoms on z = 0, +X towards the nose, +Y to the
// lander's left and x = 0 on the plane the two body halves join at.
// Arms: the key on each arm's base was matched to the key on the body (scripts/measure_nasa_stl.py).
// The HGA and the two E-field rods only press into place, so their positions are read off the guide's
// orthographic views. The DrACO is on the +Y side here.

/* [View] */
// Scale up from print size. The guide says 1:23.5.
scale_up = 23.5;
// Downward tilt of the dish towards the tail, in degrees, as in the guide's side view
dish_tilt = 7;
show_body = true;
show_arms = true;
show_hga = true;
show_draco = true;
show_efield = true;

/* [Hidden] */
stl_dir = "../source_data/nasa_model/stl/Dragonfly - LV - Part ";
foam = [0.72, 0.72, 0.70];
arm_colour = [0.45, 0.47, 0.5];
hga = [0.8, 0.65, 0.3];

module part(name) { scale(1000) import(str(stl_dir, name, ".stl")); }

// In print mm: x = Xp + t[0]; y = s Zp + t[1]; z = -s Yp + t[2], s = 1 on the left and -1 on the right.
module arm(name, t, s) {
    multmatrix([[1, 0, 0, t[0]], [0, 0, s, t[1]], [0, -s, 0, t[2]], [0, 0, 0, 1]]) part(name);
}

scale(scale_up) {
    if (show_body) color(foam) {
        multmatrix([[0, 0, -1, 0], [0, 1, 0, 283.525], [1, 0, 0, -9], [0, 0, 0, 1]]) part("01 (Body Back)");
        multmatrix([[0, 0, 1, 0], [0, 1, 0, 282.925], [-1, 0, 0, -13.63], [0, 0, 0, 1]]) part("02 (Body Front)");
    }
    if (show_arms) color(arm_colour) {
        arm("07 (Prop Front Right - Spin Loose)", [15.90, -23.77, 246.84], -1);
        arm("08 (Prop Back Right - Spin Loose)", [8.51, -24.75, 247.41], -1);
        arm("09 (Prop Front Left - Spin Loose)", [15.91, 23.77, -137.05], 1);
        arm("10 (Prop Back Left - Spin Loose)", [9.89, 24.75, -137.62], 1);
    }
    if (show_hga) {
        // Base in the deck's round inset (centre x = -4, floor z = 43.91), mount on it, dish on the axle
        color(arm_colour) translate([-4 - 58.19, 235.96, 43.91]) part("03 (HGA Base)");
        color(arm_colour) translate([-4, 0, 47.41]) rotate([0, 0, 180]) translate([-60.05, 212.42, 0]) part("04 (HGA Mount)");
        color(hga) translate([-4 - 2, 0, 47.41 + 4.03]) rotate([0, -dish_tilt, 0])
            multmatrix([[-1, 0, 0, 41.6], [0, 1, 0, 181.49], [0, 0, -1, 8.75], [0, 0, 0, 1]]) part("05 (HGA Dish)");
    }
    if (show_draco) color(arm_colour) // base against the fuselage side, as in step 3 of the guide
        translate([7, 20.6, 14]) translate([58.19, 237.65, 0]) part("06 (Draco)");
    if (show_efield) color(hga) {
        // Rods from the guide's steps 6 and 7. Print-plate Y runs along each rod.
        translate([62, -15, 22]) rotate([0, 0, -62]) translate([3.35, 267.45, 0]) part("12 (EFIELD Antenna Front)");
        translate([-83, 17, 20]) rotate([0, 0, 125]) translate([3.35, 296.5, 0]) part("11 (EFIELD Antenna Back)");
    }
}
