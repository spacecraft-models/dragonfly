# Dragonfly dimensions

Dragonfly is NASA's rotorcraft lander for Titan, led by Johns Hopkins APL. All main figures are for the flight lander as being built in 2026. Metric comes first, with feet or inches in brackets. Compiled 2026-11-04.

Each figure is tagged **Published** (NASA or APL), **Reported** (a conference paper or Wikipedia), **Measured** (from NASA's printable model, whose own limits are given below) or **Estimated** (from photos or renderings, with the method given). Gaps are left as gaps and listed under "Not published". [source_data.md](source_data.md) has a link to every original, and shows how each figure was taken.

## Published overall figures

| Dimension | Value | Tag |
|---|---|---|
| Mass | 875 kg (1,900 lb) | **Published** |
| Length and width | 3.85 m (12.5 ft) each | **Published** |
| Height | 1.75 m. NASA's own bracket says 5.5 ft, which is 1.68 m | **Published** |
| Rotors | Eight, 1.35 m (53 in), in coaxial pairs on four arms | **Published** |
| Rotor type | Three-bladed, fixed pitch | **Reported** (SciTech paper) |
| Fuselage length | About 4 m (13 ft) including its frame's power-source cap | **Published** |
| High-gain antenna (HGA) | 87.4 cm (34.4 in) | **Published** |
| MMRTG | 64 cm across, 66 cm long | **Published** (generic flight unit, not Dragonfly-specific) |
| Foam | 7.6 cm (3 in) of Solimide-based foam | **Published** |
| Primary structure | About 104 kg (230 lb) | **Published** |
| Harness | About 45 kg (100 lb) | **Published** |
| Battery | 134 Ah, nearly 136 kg (300 lb) | **Published** |

### Where the published figures disagree

- **Length.** 3.85 m can't be the whole lander. Photos and the print model put nose to MMRTG cap at about 4.1 m (13.4 ft; 4.14 m in the model without the nose's rod), which is what NASA's "13 ft" describes. The 3.85 m is about right for the rotor-tip width, and may have been an earlier design's figure for the length too.
- **Height.** The fins' tops are at about 1.58 m, and the raised HGA reaches about 2.05 m in a rendering and 2.13 m in the model at 70°. Neither gives 1.75 m. The hood is 1.45 m.
- **Landing mass.** Wikipedia still gives about 450 kg, an older figure.
- **Aeroshell.** The SciTech paper gives 4.5 m and Wikipedia 3.7 m. The paper is newer, and only 4.5 m fits a 4.1 m lander.

## Reference frame

- **Origin:** z = 0 is the plane under the skids, and x = 0 is halfway between the front and rear rotor axes on y = 0, the centreline.
- **Axes:** +x points to the nose, +y to the lander's left, +z up.
- **Pose:** on the ground. The HGA's elevation is 0° when stowed flat with its face up, and rises as the dish swings up with its face turning towards the nose.

## How the sizes were worked out

The print model has the outer shape but is too short in the middle. The hardware photos have the true proportions but no scale of their own. So the model takes the fuselage box from the photos, and takes parts the photos don't show from the print model, at its own scale.

### NASA's printable model

The "Dragonfly LV" model is 14 STL files with two guides. It was built in Blender "using only publicly available imagery" (print guide), so it is a careful artist's model, not CAD. `scripts/nasa_assembly.scad` reassembles it and `scripts/measure_nasa_stl.py` measures it.

| Feature | Print size | Real size | Implied scale |
|---|---|---|---|
| Rotor diameter | 56.6 mm | 1.35 m | 1:23.9 |
| Width across the rotors | 162.9 mm | 3.85 m | 1:23.6 |
| Nose to MMRTG | 170.9 mm | About 4.1 m (photos) | 1:24.0 |
| HGA dish | 36.0 mm | 87.4 cm | 1:24.3 |
| MMRTG can | 27.8 mm | 65 cm (photo) | 1:23.4 |
| Top of the tail fins | 67.3 mm | 1.75 m | 1:26.0, but see above |

The guide's 1:23.5 holds, and **Measured** figures below use it.

### The hardware photo's scale

The June 1, 2026 vibration table photo is nearly side on, and shows the whole bare fuselage. The scale, 0.53 px/mm on the 3000 px original, ± about 5%, comes from the MMRTG can, NASA's 13 ft and the people in the frame; [source_data.md](source_data.md#lander-lifted-to-the-vibration-table) has the working.

**The lander in this photo is upside down**, going deck-first on to its fixture. The tap test photo of May 12 shows the right way up.

### What the photos changed

| Figure | Print model | Hardware photo | Used |
|---|---|---|---|
| Front to rear rotor axes | 1610 mm | 1736 mm | 1736 mm |
| Foam-covered depth | 735 mm | 699 mm | 699 mm |
| Arm below the foam deck | 169 mm | 199 mm | 199 mm |
| Length of the hood | 1094 mm | 944 mm | 944 mm |
| Legs and skids | Blocky, with the skid track given | Bent strip legs and flat plate skids | Photo's form, print model's sizes |
| Arm near the body | Thick fairing | Bare tube on a bolted block, foam sleeve in renderings | Block and tube; sleeve with the foam |
| HGA mount | Round motor on a swivel | Truss pyramid with gimbal block | Truss pyramid |
| Can | Plain with a stepped end | Ribbed silver can with a gold fluted cap | Photo's form |

## Fuselage

### Bare box

All **Estimated** from the vibration table photo, with its ± 5% scale, unless noted. Without foam it is a long, plain aluminium box, with its rear wall leaning so that the belly reaches further back than the deck.

| Item | Value |
|---|---|
| Belly | z = 430 mm (the print model's foam belly at 354 mm, plus the foam) |
| Deck | z = 977 mm, so 547 mm deep |
| Width | 830 mm: print model's mid-body width (980 mm with foam), less the foam (**Measured**, not in the photos) |
| Length along the belly | 3274 mm, x = -1425 to +1849 mm |
| Length along the deck | 3028 mm, x = -1179 to +1849 mm |
| Rear wall | Runs from x = -1425 at the belly to x = -1179 at the deck, so it leans 24° from vertical |
| Front of the belly | Rises 57 mm over the front 283 mm |
| Top of the box at the nose | Dips about 55 mm forward of x = 981 mm, which is where the hood's rear wall sits |

### Foam

The foam is 76 mm (**Published**), so the hull is the box plus 76 mm all round except as listed. Its outer shape is **Measured** from the print model, then stretched along x to fit the box.

| Item | Value |
|---|---|
| Foam belly | z = 354 mm |
| Foam deck | z = 1053 mm |
| Half-width | 490 mm |
| Hood | x = 981 mm to the nose at x = 1925 mm |
| Hood top | z = 1454 mm, so it stands 401 mm above the deck |
| Hood half-width | 487 mm, narrowing to 300 mm at the nose |
| Hood's rounded top corners | Radius about 120 mm |
| Raised side panels | About 40 mm proud (**Measured**) |

Hood profile, from the rear wall forward, as stretched:

| x (mm) | Belly z | Top z | Half-width |
|---|---|---|---|
| 1062 | 360 | 1454 | 487 |
| 1224 | 400 | 1446 | 487 |
| 1427 | 449 | 1403 | 487 |
| 1630 | 482 | 1296 | 475 |
| 1752 | 509 | 1178 | 403 |
| 1833 | 547 | 1055 | 385 |
| 1894 | 651 | 925 | 364 |
| 1925 | 730 | 860 | 300 |

### Details on the hull

All from the renderings and print model, with positions **Estimated**.

| Item | Detail |
|---|---|
| Nose cameras | Three each side, in gold-sided housings with dark windows: side, upper front and lower front. Housing about 170 × 170 mm. |
| Pipes and fans | Thin pipes up the hood's sides to two dark slots each, with a canned fan low on each side, which fits the TFAWS talk's "ducting fans" |
| E-field rods | Two, 392 mm long with a ball on the end (**Measured**): one on the nose, one at the rear |
| Deck | A pot, plate and mast at the rear (LGA and MGA), a small pyramid mount mid-deck |

## MMRTG

| Item | Value | Tag |
|---|---|---|
| Can | 650 mm across, 487 mm long, ribbed and panelled silver | **Estimated**, against the published 64 cm |
| Cap | 560 mm across, 325 mm long, gold and fluted | **Estimated** |
| Axis | 24° above horizontal, pointing back: square to the rear wall | **Estimated** |
| Tip | x = about -2210 mm | **Estimated** |

The print model's can is 654 mm across, which agrees. A can this size spans the rear wall, as in the photo.

## Tail fins

Two bronze plates either side of the MMRTG. Their outline is **Measured** from the print model; the front is placed at the deck's rear edge from the photos and renderings.

| Item | Value |
|---|---|
| Size | 832 mm long, 450 to 1582 mm high (**Measured**) |
| Splay | Rear edges 13.4° further out than the fronts, from y = ±380 mm to about ±545 mm (**Measured**) |
| Finish | Bronze-gold. The renderings show a honeycomb texture and the May 2026 photo a plain bronze plate. |

## Rotors and arms

| Item | Value | Tag |
|---|---|---|
| Diameter | 1350 mm | **Published**; print model 1330 mm |
| Rotor axes | x = ±868 mm, y = ±1250 mm | **Estimated** for x. y from the published 3.85 m width and 1.35 m rotors. |
| Discs | z = 636 and 976 mm, 340 mm apart | **Measured** for spacing, against 285 to 320 mm in a rendering |
| Arm | z = 854 mm; tube about 110 mm tapering to 85 mm | **Estimated** |
| Foam sleeve on the arm | 210 mm across, out to y = ±725 mm | **Estimated** from renderings |
| Fairing over each arm root | ±210 mm along x, out to y = ±565 mm, z = 760 to 1053 mm | **Measured**, shortened to clear the disc |
| Blade chord | 125 to 128 mm in the inner third, tapering to about 90 mm, then pointed at the tip; narrow at the root | **Measured**, with root and tip from photos |
| Blade pitch | 21.5° flat in the print model | **Measured**. Real blades are surely twisted, but nothing gives by how much |
| Blade tips out of plane | Upper rotors about 5° down, lower about 5° up in the print model; photos and renderings don't settle it, so the model draws 0° | **Measured** |
| Hub | Motor about 200 mm across, 130 mm tall on each side of the arm | **Measured** |

## Skids, legs and drills

| Item | Value | Tag |
|---|---|---|
| Skids | Two, centre to centre 1466 mm, 173 mm wide | **Measured** |
| Skid length | 2434 mm, x = ±1217 mm | **Estimated**: the print model's overhang of 349 mm past the legs |
| Skid ends | Bottom rises from 303 mm before the tip, tip top at z = 172 mm | **Measured** |
| Leg position | Under the arms, x = ±868 mm | **Estimated** from the tap test photo |
| Leg strip | 90 mm wide bent strip, widening towards the skid, out to y = ±905 mm | **Measured** for reach; form from the tap test photo |
| Drill pack (DrACO) | 243 × 204 × 657 mm, with two drill tubes. Print model has one on the side of the hull, Wikipedia one on each skid, and renderings show hardware on both. The model has one each side. | **Measured**, **Reported** |

## High-gain antenna

| Item | Value | Tag |
|---|---|---|
| Dish | 874 mm across, about 25 mm thick | **Published** across; **Estimated** thick from the May 14, 2026 photo |
| Type | Radial line slot antenna: foam between two slotted metal plates | **Published** |
| Slots | About 12 rings of right-angled slot pairs, 30 mm apart, six pads round the centre | **Estimated** from the chamber photo |
| Mount | Truss pyramid on the deck, x = 179 mm, 483 mm across (**Measured**) with gimbal block on top, axle at z = 1233 mm | **Estimated** from the May 14 photo |
| Raised | Elevation about 70° in the renderings, with a top about 2.05 m there and 2.13 m in the model | **Estimated** |
| Launch lock | A post on the deck under the dish's far edge when stowed | **Estimated** |

## Colours

| Part | Colour | Source |
|---|---|---|
| Bare box sides | Dull grey aluminium, yellow-gold tape along every edge | May and June 2026 photos |
| Bare belly and rear wall | Pale gold | May and April 2026 photos |
| Foam | **Not published.** Every rendering shows a wrinkled champagne-silver metallised skin. The only photo of real foam, the insulation test section, has glossy orange polyimide film. `foam_finish` offers both. The orange film is the default, Tom's choice, as it is the only finish seen on real foam. | Renderings; insulation photo |
| HGA | Orange-gold face, yellow-gold rim, copper back | Chamber and May 14 photos |
| MMRTG | Bright silver can, pale gold cap | June 2026 photo |
| Fins | Bronze-gold | Renderings, May 2026 photo |
| Blades | Dark carbon with black and white tip bands | Rotor test photo |
| Hubs and arms | Silver, with dark caps | Photos, renderings |
| Legs | Grey metal | May 2026 photo |
| Skids | Pale gold | May 2026 photo |

## Fit in the aeroshell

The aeroshell is 4.5 m across, a 60° sphere-cone with a biconic backshell (**Reported**). The lander is about 4.1 m long and 3.85 m across its rotor tips, and the arms are restrained during entry. It is lowered about 1 m out of the backshell on its pose mechanism before release (**Reported**). The tight fit is another reason to believe the shorter end of the scale's range.

## Not published

- A general arrangement drawing. NASA and APL publish only the overall figures above.
- The flight foam's outer finish.
- Rotor spacing, blade chord and twist.
- Skid, leg and drill dimensions.
- The exact positions of the rotor axes, though the photos narrow them down.

## Sources

Links and notes are in [source_data.md](source_data.md).

- NASA, Dragonfly spacecraft and instruments, and APL's Dragonfly site
- NASA Dragonfly blog, 2026 posts, and APL's September 8, 2025 release
- NASA's Dragonfly LV print model and guides
- 2026 SciTech entry, descent and landing paper; TFAWS 2023 thermal talk
- Wikipedia, Dragonfly (Titan space probe)
