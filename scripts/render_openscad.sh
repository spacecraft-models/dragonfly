#!/usr/bin/env bash
# Render an OpenSCAD model from three angles, export an STL and build a summary sheet.
# Usage: [EDGES=0] scripts/render_openscad.sh MODEL.scad [OUTDIR]
# OUTDIR defaults to renders/<model name>. Colours come from the model's color() calls.
# Facet edges are outlined unless EDGES=0, which suits curved models with many facets.
set -euo pipefail
[ $# -ge 1 ] || { echo "usage: $0 MODEL.scad [OUTDIR]" >&2; exit 2; }
here="$(cd "$(dirname "$0")" && pwd)"
model="$(realpath "$1")"
name="$(basename "${model%.*}")"
out="$(realpath -m "${2:-$here/../renders/$name}")"
mkdir -p "$out"

common=(--imgsize=1000,800 --projection=ortho --colorscheme=Tomorrow --viewall --autocenter)
[ "${EDGES:-1}" = 0 ] || common+=(--view=edges)
for v in "isometric:1,-1,1" "front_right_low:2,-1,0.6" "back_left_high:-1,1.5,2"; do
  view=${v%%:*}; eye=${v#*:}
  openscad -q -o "$out/${name}_$view.png" "${common[@]}" --camera="$eye,0,0,0" "$model"
  echo "RENDER $view"
done
openscad -q -o "$out/$name.stl" "$model"
py="$here/../source_data/.venv/bin/python"
[ -x "$py" ] || py=python3
"$py" "$here/make_sheet.py" "$out" "$model" "OpenSCAD $(openscad --version 2>&1 | awk '{print $3}')"
