#!/usr/bin/env python3
"""Measure a model's STL and lay its three renders out on a 2x2 summary sheet.

Usage: make_sheet.py OUTDIR MODEL TOOL

Reads OUTDIR/<name>_{isometric,front_right_low,back_left_high}.png and OUTDIR/<name>.stl,
where <name> is MODEL's file name without its extension, and writes OUTDIR/<name>_sheet.png.
TOOL is printed on the sheet, e.g. "OpenSCAD 2021.01". Called by the render_*.sh scripts.
"""
import os
import re
import struct
import sys

from PIL import Image, ImageDraw, ImageFont

VIEWS = [("isometric", "Isometric"), ("front_right_low", "Front-right, low"),
         ("back_left_high", "Back-left, high")]
FONTS = "/usr/share/fonts/truetype/dejavu/"
W, H = 1000, 800


def read_stl(path):
    """Return the triangles (three xyz tuples each) of an ASCII or binary STL."""
    data = open(path, "rb").read()
    if len(data) >= 84:
        n = struct.unpack_from("<I", data, 80)[0]
        if len(data) == 84 + 50 * n:
            facets = (struct.unpack_from("<12f", data, 84 + 50 * i) for i in range(n))
            return [(f[3:6], f[6:9], f[9:12]) for f in facets]
    v = [tuple(map(float, m)) for m in re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", data)]
    return [tuple(v[i:i + 3]) for i in range(0, len(v), 3)]


def num(v):
    v = 0.0 if abs(v) < 0.005 else v
    return f"{v:.2f}".rstrip("0").rstrip(".")


def fit(draw, text, path, size, width):
    """Largest font of at most `size` px, down to 18 px, that fits `text` into `width`."""
    while size > 18 and draw.textlength(text, font=ImageFont.truetype(path, size)) > width:
        size -= 2
    return ImageFont.truetype(path, size)


def main(outdir, model, tool):
    name = os.path.splitext(os.path.basename(model))[0]
    tris = read_stl(os.path.join(outdir, f"{name}.stl"))
    pts = [p for t in tris for p in t]
    lo = [min(p[i] for p in pts) for i in range(3)]
    hi = [max(p[i] for p in pts) for i in range(3)]
    vol = sum(a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
              + a[2] * (b[0] * c[1] - b[1] * c[0]) for a, b, c in tris) / 6  # mm³
    volume = f"{vol / 1e9:.3f} m³" if abs(vol) >= 1e8 else f"{vol / 1e3:.1f} cm³"

    images = [Image.open(os.path.join(outdir, f"{name}_{v}.png")).convert("RGB") for v, _ in VIEWS]
    sheet = Image.new("RGB", (2 * W, 2 * H), images[0].getpixel((5, 5)))
    d = ImageDraw.Draw(sheet)
    label = ImageFont.truetype(FONTS + "DejaVuSans.ttf", 34)
    for i, ((_, text), img) in enumerate(zip(VIEWS, images)):
        x, y = (i % 2) * W, (i // 2) * H
        sheet.paste(img, (x, y))
        d.text((x + 30, y + 25), text, font=label, fill=(90, 90, 90))

    x, y, width = W + 70, H + 150, W - 140
    title = os.path.basename(model)
    d.text((x, y), title, font=fit(d, title, FONTS + "DejaVuSans-Bold.ttf", 50, width), fill=(30, 30, 30))
    lines = [f"Size: {num(hi[0] - lo[0])} × {num(hi[1] - lo[1])} × {num(hi[2] - lo[2])} mm",
             f"Volume: {volume}",
             "Bounding box (mm):",
             f"  ({', '.join(map(num, lo))}) → ({', '.join(map(num, hi))})",
             f"Mesh: {len(tris)} triangles",
             f"Rendered with {tool}"]
    for j, line in enumerate(lines):
        font = fit(d, line, FONTS + "DejaVuSans.ttf", 34, width)
        d.text((x, y + 100 + j * 62), line, font=font, fill=(60, 60, 60))
    d.line([(W, 0), (W, 2 * H)], fill=(220, 220, 220), width=2)
    d.line([(0, H), (2 * W, H)], fill=(220, 220, 220), width=2)

    path = os.path.join(outdir, f"{name}_sheet.png")
    sheet.save(path, optimize=True)
    print("SHEET", path, "|", lines[0], "|", lines[1], "|", lines[4])


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    main(*sys.argv[1:])
