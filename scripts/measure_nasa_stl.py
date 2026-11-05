#!/usr/bin/env python3
"""Measure NASA's Dragonfly LV STLs after reassembling them, for spacecraft_details/dimensions.md.

Usage: source_data/.venv/bin/python scripts/measure_nasa_stl.py [SCALE]

Prints print-size millimetres and, at SCALE (default 23.5, the print guide's scale), full-size
millimetres, in the frame of scripts/nasa_assembly.scad: x towards the nose, y left, z up from the
skid bottoms, x = 0 on the plane the body halves join at.
"""
import os
import sys

import numpy as np
import trimesh

K = float(sys.argv[1]) if len(sys.argv) > 1 else 23.5
STL = os.path.join(os.path.dirname(__file__), "..", "source_data", "nasa_model", "stl",
                   "Dragonfly - LV - Part %s.stl")
BACK = np.array([[0, 0, -1000, 0], [0, 1000, 0, 283.525], [1000, 0, 0, -9], [0, 0, 0, 1.]])
FRONT = np.array([[0, 0, 1000, 0], [0, 1000, 0, 282.925], [-1000, 0, 0, -13.63], [0, 0, 0, 1.]])
ARM_L = np.array([[1000, 0, 0, 0], [0, 0, 1000, 0], [0, -1000, 0, 0], [0, 0, 0, 1.]])


def load(name, tf):
    m = trimesh.load(STL % name, process=True)
    m.apply_transform(tf)
    return m


def show(label, lo, hi):
    lo, hi = np.asarray(lo), np.asarray(hi)
    print(f"{label:34s} x {lo[0]:7.2f} {hi[0]:7.2f}  y {lo[1]:7.2f} {hi[1]:7.2f}  z {lo[2]:6.2f} {hi[2]:6.2f}"
          f"  | full size mm: {' x '.join(f'{v:.0f}' for v in (hi - lo) * K)}")


back, front = load("01 (Body Back)", BACK), load("02 (Body Front)", FRONT)
parts = back.split(only_watertight=False) + front.split(only_watertight=False)
show("whole body with skids", np.minimum(back.bounds[0], front.bounds[0]), np.maximum(back.bounds[1], front.bounds[1]))
for label, want in [("MMRTG can (aft)", (-96.31, -59.72)), ("left tail fin", (-94.12, -58.60))]:
    m = [p for p in parts if abs(p.bounds[0][0] - want[0]) < .02 and abs(p.bounds[1][0] - want[1]) < .02][0]
    show(label, *m.bounds)
    if "MMRTG" in label:
        v = m.vertices - m.vertices.mean(0)
        axis = np.linalg.svd(v[np.abs(v[:, 1]) < 3], full_matrices=False)[2]
        hist = np.linalg.svd(v, full_matrices=False)[2]
        print("   principal axes", hist.round(3).tolist(), " width in y", (m.bounds[1][1] - m.bounds[0][1]) * K)
for label, x in [("skid (x<0 half)", -30), ("skid (x>0 half)", 20)]:
    m = [p for p in parts if 27 < p.bounds[0][1] < 28 and p.bounds[1][2] < 8 and p.bounds[0][0] < x < p.bounds[1][0]][0]
    show(label, *m.bounds)
for label, x in [("rear leg", -44), ("front leg", 23)]:
    m = [p for p in parts if 26 < p.bounds[0][1] < 28 and p.bounds[0][0] < x < p.bounds[1][0] and p.bounds[1][2] > 20][0]
    show(label, *m.bounds)
    m = [p for p in parts if 18 < p.bounds[0][1] < 19 and p.bounds[0][0] < x < p.bounds[1][0] and p.bounds[1][2] < 23 and p.bounds[0][2] > 14][0]
    show(label + " top stub", *m.bounds)

print("\nfuselage sections on x: [belly z, top z on the centreline, half-width] in print mm")
for x in (-90, -80, -70, -60, -50, -40, -20, 2, 10, 20, 30, 40, 50, 60, 70, 74):
    s = (back if x < 0 else front).section(plane_origin=[x, 0, 0], plane_normal=[1, 0, 0])
    v = np.vstack(s.discrete)
    w = v[(np.abs(v[:, 1]) < 26) & (v[:, 2] > 9)]
    print(f"  x {x:4d}: z {w[:, 2].min():6.2f} to {w[:, 2].max():6.2f}, half-width {np.abs(w[:, 1]).max():5.2f}")

print("\nrotors (print-plate parts; the disc plane is the plate's XZ)")
for name in ("07 (Prop Front Right - Spin Loose)", "08 (Prop Back Right - Spin Loose)",
             "09 (Prop Front Left - Spin Loose)", "10 (Prop Back Left - Spin Loose)"):
    m = load(name, np.diag([1000, 1000, 1000, 1.]))
    comps = sorted(m.split(only_watertight=False), key=lambda p: -len(p.faces))
    for b in comps[:2]:
        lo, hi = b.bounds
        side = hi[0] - lo[0]
        R = side / 3 ** .5
        print(f"  {name[:2]} rotor: disc width {side:.2f}, height {hi[2] - lo[2]:.2f} -> R {R:.2f}, D {2 * R:.2f} "
              f"= {2 * R * K:.0f} mm; Y centre {(lo[1] + hi[1]) / 2:.2f}, Y thickness {hi[1] - lo[1]:.2f}; "
              f"axis at X {(lo[0] + hi[0]) / 2:.2f}, Z {hi[2] - R:.2f}")

print("\nblade shape, part 09's first rotor: blade pointing up the plate's Z")
b = sorted(load("09 (Prop Front Left - Spin Loose)", np.diag([1000, 1000, 1000, 1.])).split(only_watertight=False),
           key=lambda p: -len(p.faces))[0]
cx, cz = (b.bounds[0][0] + b.bounds[1][0]) / 2, b.bounds[1][2] - (b.bounds[1][0] - b.bounds[0][0]) / 3 ** .5
for r in (4, 6, 8, 10, 13, 16, 19, 22, 25, 27):
    s = b.section(plane_origin=[0, 0, cz + r], plane_normal=[0, 0, 1])
    if s is None:
        continue
    v = np.vstack(s.discrete)
    v = v[np.abs(v[:, 0] - cx) < 6]
    if len(v) == 0:
        continue
    c = np.linalg.svd(v[:, :2] - v[:, :2].mean(0))[2][0]
    print(f"  r {r:3d} ({r * K:5.0f} mm): chord x {v[:, 0].max() - v[:, 0].min():5.2f}, thick y {v[:, 1].max() - v[:, 1].min():5.2f}, "
          f"chord line {np.degrees(np.arctan2(abs(c[1]), abs(c[0]))):5.1f} deg, height y {(v[:, 1].mean()):8.2f}")
