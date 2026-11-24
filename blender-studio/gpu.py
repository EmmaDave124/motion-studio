"""
gpu.py: pick the fastest render device. Pass it on EVERY render:
    blender -b scene.blend -P gpu.py -P render.py -- ...
The GPU choice is a Blender preference, not saved in the .blend file.

Apple Silicon Macs use METAL. NVIDIA uses OPTIX/CUDA, AMD uses HIP.
Falls back to CPU if no GPU is found.
"""
import bpy

prefs = bpy.context.preferences.addons["cycles"].preferences
chosen = None
for backend in ("METAL", "OPTIX", "CUDA", "HIP", "ONEAPI"):
    try:
        prefs.compute_device_type = backend
        prefs.get_devices()
        gpus = [d for d in prefs.devices if d.type != "CPU"]
        if gpus:
            for d in prefs.devices:
                d.use = True
            chosen = backend
            break
    except TypeError:
        continue

for scene in bpy.data.scenes:
    scene.render.engine = "CYCLES"
    scene.cycles.device = "GPU" if chosen else "CPU"

print(f"[gpu.py] render device: {chosen or 'CPU'}")
