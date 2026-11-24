"""
scene.py: builds the Blender scene for ONE film and saves scene.blend.

This is a blank starter: a plain grey sphere, one light and a camera, only so
the setup can prove Blender renders. It is not a look to build on. Replace the
whole scene with what the user's brief describes.

Run:  blender -b -P scene.py
Tip: key every animated value on every frame, so any frame can render on its own.
"""
import os
import sys

import bpy

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import timeline as T  # noqa: E402

bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene
scene.frame_start, scene.frame_end = 1, T.FRAMES
scene.render.fps = T.FPS
scene.render.resolution_x, scene.render.resolution_y = T.WIDTH, T.HEIGHT
scene.render.engine = "CYCLES"
scene.cycles.samples = 64
scene.cycles.use_denoising = True
scene.render.image_settings.file_format = "PNG"

world = bpy.data.worlds.new("World")
scene.world = world
world.use_nodes = True
world.node_tree.nodes["Background"].inputs["Color"].default_value = (0.5, 0.5, 0.5, 1)
world.node_tree.nodes["Background"].inputs["Strength"].default_value = 0.6

bpy.ops.mesh.primitive_uv_sphere_add(radius=1, location=(0, 0, 0))
bpy.ops.object.shade_smooth()

bpy.ops.object.light_add(type="AREA", location=(3, -3, 4))
bpy.context.object.data.energy = 400

bpy.ops.object.camera_add(location=(0, -6, 1.5), rotation=(1.35, 0, 0))
scene.camera = bpy.context.object

out = os.path.join(HERE, "scene.blend")
bpy.ops.wm.save_as_mainfile(filepath=out)
print(f"[scene.py] saved {out}")
