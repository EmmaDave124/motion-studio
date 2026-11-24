"""
render.py: render any frame range, skipping frames that already exist.

  blender -b scene.blend -P gpu.py -P render.py -- --frames 1-180 --out renders/full
  blender -b scene.blend -P gpu.py -P render.py -- --frames 1-180:10 --out renders/stills --half --samples 32
  blender -b scene.blend -P gpu.py -P render.py -- --frames 40-60,120-180 --out renders/full --force

--frames  ranges like 1-180, 5,9,12 or 1-180:10 (every 10th frame)
--half    50% resolution for quick checks
--samples override sample count
--force   re-render even if the PNG exists
"""
import argparse
import os
import sys

import bpy

argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
ap = argparse.ArgumentParser()
ap.add_argument("--frames", default="1-%d" % bpy.context.scene.frame_end)
ap.add_argument("--out", default="renders/full")
ap.add_argument("--half", action="store_true")
ap.add_argument("--pct", type=int)
ap.add_argument("--samples", type=int)
ap.add_argument("--force", action="store_true")
a = ap.parse_args(argv)


def parse_frames(spec):
    frames = []
    for part in spec.split(","):
        step = 1
        if ":" in part:
            part, step = part.split(":")
            step = int(step)
        if "-" in part:
            s, e = map(int, part.split("-"))
            frames += list(range(s, e + 1, step))
        else:
            frames.append(int(part))
    return sorted(set(frames))


scene = bpy.context.scene
if a.half:
    scene.render.resolution_percentage = 50
if a.pct:
    scene.render.resolution_percentage = a.pct
if a.samples:
    scene.cycles.samples = a.samples

blend_dir = os.path.dirname(bpy.data.filepath)
out_dir = a.out if os.path.isabs(a.out) else os.path.join(blend_dir, a.out)
os.makedirs(out_dir, exist_ok=True)

for f in parse_frames(a.frames):
    path = os.path.join(out_dir, f"f_{f:04d}.png")
    if os.path.exists(path) and os.path.getsize(path) > 0 and not a.force:
        continue
    scene.frame_set(f)
    scene.render.filepath = path
    bpy.ops.render.render(write_still=True)
    print(f"[render.py] frame {f} -> {path}")
