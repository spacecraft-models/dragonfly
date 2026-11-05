# Source data

Every source the Dragonfly dimensions and the model use, one entry each: a link to the original, what it shows, what was measured or read from it and how, and which model settings use the result. The aim is that anyone can check a figure, or measure it again and get the same answer.

The images belong to NASA, Johns Hopkins APL and their other publishers, so they aren't in this repo. "Saved as" is a file's name in the git-ignored `source_data/img/` folder; saving a copy under that name keeps it in step with these notes. For NASA's images, the links go to the full-size file.

## How the figures were taken

- **Frame.** x, y and z are the frame in [dimensions.md](dimensions.md#reference-frame).
- **The photo scale.** Almost every photo length comes from the side-on view of the fuselage in [Lander lifted to the vibration table](#lander-lifted-to-the-vibration-table), at 0.53 px/mm on the 3000 px original. That section says how the scale was worked out.
- **Perspective.** The hardware photos were taken with wide lenses, so a part nearer the camera looks bigger and further from the middle of the frame than one further away. Lengths are measured between parts at about the same depth where possible. Where they aren't, the section gives the correction.
- **Renderings.** NASA's renderings show the design at the time they were made. Where one disagrees with a photo of flight hardware, the photo wins. Renderings are used for what the photos can't show yet: the foam's outer shape, and the arrangement of parts not yet fitted.
- **Print model.** NASA's printable model was built from public imagery in Blender, so it is a careful reading of the renderings, not a drawing. It is measured directly, which gives far better figures than a photo for parts the hardware doesn't yet show, such as the blades.

## Printable model

### NASA's Dragonfly LV print model

- **Source:** [NASA 3D Resources: Dragonfly](https://science.nasa.gov/3d-resources/dragonfly/)
- **Saved as:** `source_data/nasa_model/`: `stl/` (14 parts), `Print_Guide.pdf`, `Assembly_Guide.pdf`, `Dragonfly_STL_Files.zip`
- **Shows:** the whole lander at 1:23.5, foam shape included, split into body halves, four arm-and-rotor assemblies, HGA parts, one DrACO and two E-field rods. The guides say it was developed "using only publicly available imagery" in Blender, by Gary Allen Backus, for Fairmont State University's outreach program.
- **How:** reassembled in `scripts/nasa_assembly.scad`. The cut faces of the body halves fix their alignment. Each arm's base has a keyed recess, a pentagon for the front arms and a triangle for the rear ones, and a brute-force fit of each recess to its raised key on the body gave a clear best match with the rotor axis upright. The HGA and rods only push in, so they are placed by comparing with the assembly guide's orthographic views (page 5). `scripts/measure_nasa_stl.py` prints the measurements.

| Quantity | Result | Used in |
|---|---|---|
| Print scale | The guide's 1:23.5 fits the rotors, span and HGA; only the height doesn't fit | dimensions.md "Print scale" |
| Blades | Three per rotor, chord 130 to 88 mm, flat 21.5° pitch, tips about 5° out of plane | `rotor.scad` `blade_table` |
| Coaxial spacing | 340 mm | `rotor.scad` `disc_spacing` |
| Foam nose outline | Top, belly and half-width at seven stations | `dragonfly.scad` `hull_sections` |
| Tail fin outline | Measured directly | `dragonfly.scad` `fin_outline` |
| Skid and leg | Track 1466 mm, skid 173 mm wide | `skid.scad` |
| DrACO pack | 243 × 204 × 657 mm with two drill tubes | `skid.scad` `drill_pack` |

## Flight hardware photos

### Lander lifted to the vibration table

- **Photo:** [2026-06-01-lift_lander_to_vibe_table-8553.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/2026-06-01-lift_lander_to_vibe_table-8553.jpg), 3000 × 2001, NASA/APL, June 1, 2026
- **Saved as:** `2026-06-01-lift_lander_to_vibe_table-8553.jpg`
- **Shows:** the bare fuselage box and MMRTG can, side on, with rotors, legs and foam not yet fitted, **upside down**: it is lowered deck-first onto its fixture. The evidence for that is that the big cylinders hanging under it are the deck's pots from the tap test photo, and the arm brackets sit on the lower edge here but on the deck edge in the tap test photo. So the can's end really faces back and up, as in the print model.
- **Scale:** 0.53 px/mm at the depth of the side panel, ± about 5%. No part of known size lies on the panel, so this comes from three figures that nearly agree:
  - The MMRTG can, 320 px across and further from the camera than the panel by a factor of about 0.93, gives 0.50 px/mm at the published 64 cm, or a little more if it is larger than the bare unit.
  - NASA's "about 13 ft" (3.96 m) for the fuselage with the power-source cap, 2180 px end to end, gives 0.55 px/mm.
  - The standing people in the same frame, allowing for their being nearer the camera, give about 0.5 px/mm.

| Quantity | How | Result | Used in |
|---|---|---|---|
| Box top length | 1735 px along the long edge, measured on the side that is really the bottom | 3270 mm at the belly | `box_rear_bottom`, `box_front` |
| Rear wall | Corners 130 px apart along the box and 290 px across it, leaning back | The belly reaches 246 mm further back than the deck | `box_rear_top`, `box_rear_bottom` |
| Box depth | 290 px, deck to belly | 547 mm | `box_depth` |
| Arm roots | Centres of the brackets, 920 px apart | 1736 mm apart | `axis_x` |
| Arm height | 65 px below the deck edge | 123 mm | `arm_z` |
| Front of the box | The belly edge rises 30 px over the front 150 px | Rises 57 mm over 283 mm | `box_front_chamfer` |
| Hood's rear limit | The deck's edge dips about 30 px, starting 980 mm forward of the mid-point | 981 mm | `hood_rear` |
| Can diameter | 320 px, at 0.93 of the panel's scale | 650 mm (published flight unit: 64 cm) | `mmrtg.scad` `can_d` |
| Can length | 240 px of ribbed silver, 160 px of gold cap | 487 and 325 mm | `mmrtg.scad` `can_len`, `cap_len` |
| Can's tilt | Square to the rear wall | Axis 24° above horizontal, pointing back | `mmrtg_tilt` |

The can's colours, the gold-fluted cap and the panel lines also come from this photo, as do the side panels' finish: dull grey aluminium with yellow-gold tape along every edge.

### Suspended tap test

- **Photo:** [2026-05-12-Dragonfly_Suspended_Tap_Test_in_VTL-8415.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/2026-05-12-Dragonfly_Suspended_Tap_Test_in_VTL-8415.jpg), 3000 × 2001, NASA/APL, May 12, 2026
- **Saved as:** `2026-05-12-Dragonfly_Suspended_Tap_Test_in_VTL-8415.jpg`
- **Shows:** the lander the right way up, without foam, from below and to one side. It has legs, skids, arms with dummy three-armed rotors, a bronze tail fin, and pots on the deck. This is the only photo with legs and skids fitted.
- **Scale:** none used; it is at too steep an angle.

| Quantity | How | Result | Used in |
|---|---|---|---|
| Skid and leg form | Looked at | The skid is a flat gold plate with an upswept angled tip. The leg is a bent grey metal strip, wide where it meets the skid, arching over to a fork under the belly. The print model's boxy legs are less accurate. | `skid.scad` |
| Leg position | Against the arms | About under the arms | `leg_x` |
| Belly finish | Looked at | Pale gold panels with round holes | `box_colour` option |
| Deck layout | Looked at | Pots towards the front | `dragonfly.scad` deck parts |

### HGA integration and launch lock

- **Photo:** [2026-05-14-HGA-intergration_and_launch_lock3996.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/2026-05-14-HGA-intergration_and_launch_lock3996.jpg), 3000 × 2001, NASA/APL, May 14, 2026
- **Saved as:** `2026-05-14-HGA-intergration_and_launch_lock3996.jpg`
- **Shows:** the HGA stowed flat over the deck. The dish is thin and has a coppery back and a yellow-gold rim. It sits on a dark truss pyramid topped by a gimbal block, and the launch lock is a post at one edge of the deck. Silvered blankets cover the deck.
- **Used in:** `hga.scad`: the truss and gimbal form, the rim and back colours. dimensions.md "HGA".

### HGA in the antenna chamber

- **Photo:** [HGA_chamber.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/HGA_chamber.jpg), 6144 × 4098, NASA/APL, 2026
- **Saved as:** `HGA_chamber.jpg`
- **Shows:** the face of the HGA, seen nearly square on, in strong orange-gold. Chevron-shaped slots run in concentric rings from a cluster of round features at the centre.
- **Scale:** the 87.4 cm dish.

| Quantity | How | Result | Used in |
|---|---|---|---|
| Slot rings | Counted along one radius on a crop | About 12 rings of right-angled slot pairs, about 30 mm apart, the slots growing from about 11 to 27 mm long towards the rim | `hga.scad` `slot_rings` |
| Centre feed | Counted | Six round pads, about 25 mm across, round the centre | `hga.scad` |
| Face colour | Sampled by eye in the lit part | Orange-gold | `hga.scad` `face` |

### Top deck fit check

- **Photo:** [FitCheck1.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/FitCheck1.jpg), 4096 × 2732, NASA/APL, April 3, 2026
- **Saved as:** `FitCheck1.jpg`
- **Shows:** the deck coming down on the box. The gold rear wall is a machined frame with a round, ribbed opening for the MMRTG mount.
- **Used in:** the box's rear wall colour; `mmrtg.scad`'s mounting ring. A rough width estimate, width about 1.45 × the rear wall's slant length, is too affected by perspective to use.

### Harness going into the fuselage

- **Photo:** [Harness1_SM.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/Harness1_SM.jpg), 4096 × 2732, NASA/APL, 2026
- **Saved as:** `Harness1_SM.jpg`
- **Shows:** the open box from the side, with bare walls, the harness inside, the gold rear wall, and an arm stub: a machined silver tube ending in a bolted flange block on the box's top edge.
- **Used in:** `dragonfly.scad`'s arm roots: the block and a bare silver tube, not the print model's thick fairing.

### Harness along the fuselage

- **Photo:** [Harness2_box_sm.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/Harness2_box_sm.jpg), 2732 × 4096, NASA/APL, 2026
- **Saved as:** `Harness2_box_sm.jpg`
- **Shows:** a view along the open box, with arm tubes leaving both sides at the far end. The harness is internal, so it isn't modelled.
- **Used in:** a check that the arms leave square to the box.

### Navcam install

- **Photo:** [Navcam Install.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/Navcam%20Install.jpg), 3300 × 2201, NASA/APL, August 19, 2026
- **Saved as:** `Navcam_Install.jpg`
- **Shows:** a camera in a gold-sided box with a splayed base, mounted on a bracket on the fuselage's nose. Black carbon-fibre-look shells are nearby.
- **Used in:** the camera housings on the nose in `dragonfly.scad`.

### Pose mechanism

- **Photo:** [PoseMechanism.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/PoseMechanism.jpg), 798 × 1080, Lockheed Martin, 2026
- **Saved as:** `PoseMechanism.jpg`
- **Shows:** the arms that lower the lander out of the backshell, on a test stand. They aren't part of the lander, so they aren't modelled.

### DraMS and sample carousel

- **Photo:** [GSFC_DRAGONFLY2.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/GSFC_DRAGONFLY2.jpg), 7914 × 5276, NASA Goddard, 2026
- **Saved as:** `GSFC_DRAGONFLY2.jpg`
- **Shows:** an instrument on its bench. It is internal, so nothing was taken from it.

### Power and electronics testing

- **Photo:** [20260312-PSU-IEM-Integration-Dragonfly.jpg](https://www.jhuapl.edu/sites/default/files/2026-03/20260312-PSU-IEM-Integration-Dragonfly.jpg), 1440 × 808, APL, March 12, 2026
- **Saved as:** `20260312-PSU-IEM-Integration-Dragonfly.jpg`
- **Shows:** the power switching unit and electronics boxes on a bench. They are internal, so nothing was taken from it.

### Electronics and harness

- **Photo:** [20260312-IEM-Harness-Dragonfly.jpg](https://www.jhuapl.edu/sites/default/files/inline-images/20260312-IEM-Harness-Dragonfly.jpg), 525 × 700, APL, March 12, 2026
- **Saved as:** `20260312-IEM-Harness-Dragonfly.jpg`
- **Shows:** an engineering-model electronics box being connected to the harness. It is internal, so nothing was taken from it.

### Parachute drop test

- **Photo:** [ParachuteTest1.JPG](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/ParachuteTest1.JPG), 4096 × 2730, NASA, February 11, 2026
- **Saved as:** `ParachuteTest1.JPG`
- **Shows:** a drop test vehicle under its parachute. It isn't part of the lander, so nothing was taken from it.

### Heat shield

- **Photo:** [20250908-Dragonfly-Heat-Shield.jpg](https://www.jhuapl.edu/sites/default/files/2025-09/20250908-Dragonfly-Heat-Shield.jpg), 550 × 367, APL, September 8, 2025
- **Saved as:** `20250908-Dragonfly-Heat-Shield.jpg`
- **Shows:** the heat shield's black cone. It isn't part of the lander, so nothing was taken from it.

### Foam insulation test section

- **Photo:** [20250908-Dragonfly-Cam-Insulation.jpg](https://www.jhuapl.edu/sites/default/files/2025-09/20250908-Dragonfly-Cam-Insulation.jpg), 800 × 534, APL, September 8, 2025
- **Saved as:** `20250908-Dragonfly-Cam-Insulation.jpg`
- **Shows:** a section of lander insulation for testing in APL's Titan chamber: foam blocks taped up in glossy orange polyimide film. It has stepped, chamfered panels and a channel for a pipe.
- **Used in:** the only direct evidence of the foam's skin. `dragonfly.scad`'s `foam_finish` option 2, the default. Whether the flight foam stays orange or gets a metallised layer isn't published; see dimensions.md, "Colours".

## Test models

### Full-scale half-width model, rotors being fitted (APL copy)

- **Photo:** [20250908-Dragonfly-Wind-Tunnel-Setup.jpg](https://www.jhuapl.edu/sites/default/files/2025-09/20250908-Dragonfly-Wind-Tunnel-Setup.jpg), 1440 × 808, APL, 2025
- **Saved as:** `20250908-Dragonfly-Wind-Tunnel-Setup.jpg`
- **Shows:** a full-scale half lander on the tunnel wall, orange-red, with real rotors and blue-painted parts. It is the best view of the foam's real outer shape: a big hood with rounded top edges and flat sides, a step down to the deck, and raised rectangular panels on the sides. The blades are bare metal, thin and pointed, with a sharply tapered tip.
- **Used in:** `hull_sections`' corner radii; `rotor.scad` `blade_table` tip shape; the tube arm with its wiring is the source of `arm_d`.

### Full-scale half-width model, rotors being fitted (NASA copy)

- **Photo:** [WindTunnelSetup.tif](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/WindTunnelSetup.tif), 1920 × 1080, NASA, 2025
- **Saved as:** `WindTunnelSetup.tif`
- **Shows:** the same scene as the APL copy, at a higher resolution, so it was used for reading the same details.

### Full-scale half-width model with the test team

- **Photo:** [20250908-Dragonfly-Langley-Test-Team.jpg](https://www.jhuapl.edu/sites/default/files/2025-09/20250908-Dragonfly-Langley-Test-Team.jpg), 1440 × 808, APL, 2025
- **Saved as:** `20250908-Dragonfly-Langley-Test-Team.jpg`
- **Shows:** the team under the model, which shows the skid arches and the arm from below.
- **Used in:** the leg's form in `skid.scad`, alongside the tap test photo.

### Half-scale model from behind

- **Photo:** [202310-Wind-Tunnel-Dragonfly.jpg](https://www.jhuapl.edu/sites/default/files/2023-10/202310-Wind-Tunnel-Dragonfly.jpg), 1440 × 808, APL, 2023
- **Saved as:** `202310-Wind-Tunnel-Dragonfly.jpg`
- **Shows:** a half-scale model on its sting in the tunnel, from behind and at an angle, with the MMRTG end and the arms.
- **Used in:** confirms the can is at the back and tilted.

### Half-scale model after testing (APL copy)

- **Photo:** [202310-Dragonfly-Wind-Tunnel-PostCheck.jpg](https://www.jhuapl.edu/sites/default/files/2023-10/202310-Dragonfly-Wind-Tunnel-PostCheck.jpg), 1440 × 808, APL, 2023
- **Saved as:** `202310-Dragonfly-Wind-Tunnel-PostCheck.jpg`
- **Shows:** the model from below and to the side, with a hood of plain white foam shaped like a long rounded loaf.
- **Used in:** `hull_sections` for the hood's shape.

### Half-scale model after testing (NASA copy)

- **Photo:** [dragonfly-testing.png](https://assets.science.nasa.gov/content/dam/science/cds/general/images/2023/09/dragonfly-testing.png), 1291 × 793, NASA, 2023
- **Saved as:** `dragonfly-testing.png`
- **Shows:** the same scene as the APL copy, framed a little differently. Nothing new was taken from it.

### Rotor in the wind tunnel

- **Photo:** [8492.jpg](https://www.universetoday.com/article_images/8492.jpg), 1200 × 800, in a Universe Today article, showing NASA/APL's rotor test at Langley
- **Saved as:** `8492.jpg`
- **Shows:** a single rotor on the wall. It has three dark blades with black and white bands at the tips, a silver hub and a silver arm wrapped with wire. The blades are widest about a third of the way out and narrow towards both ends.
- **Used in:** `rotor.scad` colours and tip bands, `blade_table`'s narrow root.

### Semi-scale full-span model

- **Photo:** [dragonfly-semi-scale-full-span-wind-tunnel-model.png](https://planetary.s3.amazonaws.com/web/assets/pictures/dragonfly-semi-scale-full-span-wind-tunnel-model.png), 3000 × 2000, The Planetary Society's copy
- **Saved as:** the same name
- **Shows:** an earlier blue full-span model in the tunnel, head on from the front. It shows the arms' layout and the skids but with no foam detail.
- **Used in:** nothing measured; it is an earlier design at an angle.

## Renderings

All of these are NASA or APL artist's concepts, and show the foam as a metallised skin, which is `foam_finish` option 1.

### Landed, 2024 factsheet still

- **Image:** [Dragonfly_2024_Factsheet-LandStill_1.jpg](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/Dragonfly_2024_Factsheet-LandStill_1.jpg), 4000 × 2250
- **Saved as:** `Dragonfly_2024_Factsheet-LandStill_1.jpg`
- **Shows:** the clearest view of the outside: hood, nose camera housings, pipes up the hood's sides to two dark slots, a canned fan, thick insulated arm roots with thin tubes beyond, rotors, skids, the raised HGA, bronze honeycomb fins, and deck pots.
- **Used in:** pipework (`duct_path`), `fan_can`, HGA pose, tip bands.

### Landed, June 2025 close-up

- **Image:** [IMG-Missions-Dragonfly-June2025.jpg](https://www.jhuapl.edu/sites/default/files/2025-06/IMG-Missions-Dragonfly-June2025.jpg), 1200 × 800
- **Saved as:** `IMG-Missions-Dragonfly-June2025.jpg`
- **Shows:** the same scene, closer in, which makes the pipes and fan easier to read.
- **Used in:** the same settings as the factsheet still.

### Landed close-up

- **Image:** [Dragonfly_Landed_Closeup.png](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/Dragonfly_Landed_Closeup.png), 2250 × 1567
- **Saved as:** the same name
- **Shows:** the left side, nearly side on, from behind. It shows the hubs' black caps, a rod on the hood's side, and two cameras low on the nose.
- **Scale:** the hubs' spacing against a blade, which agrees with the print model's 340 mm to within the accuracy of reading a rendering (285 to 320 mm).
- **Used in:** `disc_spacing`'s check; hood rod.

### Landed in the dunes

- **Image:** [Dragonfly2024_Landed-Still_AA.jpg](https://assets.science.nasa.gov/content/dam/science/missions/dragonfly/Dragonfly2024_Landed-Still_AA.jpg), 4000 × 2184
- **Saved as:** the same name
- **Shows:** the lower nose, belly and legs from low down, and clusters of drill hardware on the skids.
- **Used in:** `skid.scad`, nose housings.

### 202310-Dragonfly-Surface.jpg

- **Image:** [202310-Dragonfly-Surface.jpg](https://www.jhuapl.edu/sites/default/files/2023-10/202310-Dragonfly-Surface.jpg), 1440 × 808
- **Saved as:** `202310-Dragonfly-Surface.jpg`
- **Shows:** Landed, front quarter, with an older version of the hood. It adds no new measurement.

### Dragonfly_InForLanding.jpg

- **Image:** [Dragonfly_InForLanding.jpg](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/Dragonfly_InForLanding.jpg), 2520 × 1655
- **Saved as:** `Dragonfly_InForLanding.jpg`
- **Shows:** In flight, from the front, with rotors blurred. It adds no new measurement.

### Dragonfly-BannerFactSheet_2024.png

- **Image:** [Dragonfly-BannerFactSheet_2024.png](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/Dragonfly-BannerFactSheet_2024.png), 7500 × 3048
- **Saved as:** `Dragonfly-BannerFactSheet_2024.png`
- **Shows:** In flight over dunes. It adds no new measurement.

### dragonfly2.jpg

- **Image:** [dragonfly2.jpg](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/dragonfly2.jpg), 2598 × 1768
- **Saved as:** `dragonfly2.jpg`
- **Shows:** Landed, from above, the only good top view. It adds no new measurement.

### dragonfly-mission-overview.jpg

- **Image:** [dragonfly-mission-overview.jpg](https://assets.science.nasa.gov/content/dam/science/psd/planetary-science-division/2025/dragonfly-mission-overview.jpg), 7500 × 4776
- **Saved as:** `dragonfly-mission-overview.jpg`
- **Shows:** Entry to landing, in sequence. It adds no new measurement.

### dragonfly-departurebegin.jpg

- **Image:** [dragonfly-departurebegin.jpg](https://science.nasa.gov/wp-content/uploads/2023/11/dragonfly-departurebegin.jpg), 4000 × 2250
- **Saved as:** `dragonfly-departurebegin.jpg`
- **Shows:** From behind, showing the MMRTG end facing back and up. It adds no new measurement.

## Written sources

| Source | What it gives | Used in |
|---|---|---|
| [NASA, Dragonfly spacecraft and instruments](https://science.nasa.gov/mission/dragonfly/spacecraft-and-instruments/) and [APL's Dragonfly site](https://dragonfly.jhuapl.edu/) | Mass, overall size, rotors, battery, MMRTG; aluminium panels, honeycomb skin, polymethacrylimide-based foam | dimensions.md "Published overall figures" |
| [NASA Dragonfly blog](https://science.nasa.gov/blogs/dragonfly/), April 23, 2026 | Honeycomb panels with face sheets of about 0.01 in; primary structure about 230 lb; top deck carries telecom; MMRTG mounting plate and cover | dimensions.md "Construction" |
| NASA Dragonfly blog, July 9, 2026 | Fuselage about 13 ft long, delivered June 29; frame has skids, a power-source cap and arms for eight rotor sets. HGA 34.4 in, golden, a radial line slot antenna on a motorised arm that raises it after landing and stows it into a launch lock | The photo scale; dimensions.md "HGA" |
| [APL news release, September 8, 2025](https://www.jhuapl.edu/news/news-releases/250908b-nasas-dragonfly-soaring-through-key-development-test-activities) | 3 in (7.6 cm) of Solimide-based foam | `foam` |
| NASA Dragonfly blog, September 2, 2026 | Harness about 100 lb, battery nearly 300 lb, harness under thick outer foam | dimensions.md "Construction" |
| [2026 SciTech entry, descent and landing paper](https://ntrs.nasa.gov/citations/20250011718) | Eight three-bladed fixed-pitch rotors in pairs on four arms; 4.5 m, 60° aeroshell; lander poses about 1 m down before release near 900 m | dimensions.md "Rotors", "Fit in the aeroshell" |
| [TFAWS 2023 thermal talk, TFAWS23-AT-14](https://tfaws.nasa.gov/) | Named parts: Skid, MMRTG, Nose, Fuselage, Attic, HGA, Leg, Arm, MGA, Rotor, LGA, Ducting fans, Fin; about 2 kW of waste heat ducted through the lander | Part names; `fan_can` |
| [Wikipedia, Dragonfly (Titan space probe)](https://en.wikipedia.org/wiki/Dragonfly_(Titan_space_probe)) | Two DrACO drills, one on each skid; MGA and LGA; older mass and aeroshell figures | `skid.scad`; dimensions.md conflicts |
