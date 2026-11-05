# Dragonfly Model

A model of NASA's Dragonfly rotorcraft lander for Titan, as it is being built in 2026. The models are OpenSCAD files at full size, built from the dimensions collected in [spacecraft_details/dimensions.md](spacecraft_details/dimensions.md).

This work is not affiliated with or endorsed by NASA or Johns Hopkins APL.

## What's in the repo

| Path | What it holds |
|---|---|
| `model/dragonfly.scad` | The lander: the foam hull or the bare fuselage, arms, fins, pipes, cameras and deck parts, with the parts below |
| `model/rotor.scad` | A three-bladed rotor and the hub stack of a coaxial pair |
| `model/hga.scad` | The high-gain antenna on its mount, at any elevation |
| `model/mmrtg.scad` | The power source in its can and cap |
| `model/skid.scad` | A skid, its legs and a DrACO drill pack |
| `spacecraft_details/dimensions.md` | The sizes the models are built from, each tagged Published, Reported, Measured or Estimated, plus conflicts between the sources and what isn't published |
| `spacecraft_details/source_data.md` | Every source: a link to the original, what it shows, what was taken from it and how, and which model settings use it |
| `scripts/render_openscad.sh` | Renders a `.scad` file from three angles, exports an STL and makes a summary sheet |
| `scripts/make_sheet.py` | Lays out that summary sheet |
| `scripts/nasa_assembly.scad` | NASA's printable model, reassembled at full size, for reference |
| `scripts/measure_nasa_stl.py` | Measures that reassembled model |

Git ignores two more folders: `renders/`, where the script writes its output, and `source_data/`, local copies of NASA's printable model and the reference photos, plus a Python environment. `spacecraft_details/source_data.md` links to the originals.

## Quick start

Open any file in `model/` in OpenSCAD. To render the lander to PNGs and an STL in `renders/dragonfly/`:

```bash
EDGES=0 scripts/render_openscad.sh model/dragonfly.scad
```

The model is full size in millimetres. `dragonfly.scad`'s Customizer settings can scale it for printing, set the HGA's elevation, show the bare fuselage and change the foam's finish, which NASA hasn't published. The default is the orange polyimide film seen on real foam, and NASA's renderings' champagne-silver skin is the other option.
