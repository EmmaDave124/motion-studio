"""
timeline.py: the single source of truth for ONE film.

This is a blank starter. Fill it from the user's brief. Nothing here is a style:
the numbers below only exist so the starter scene can render a test frame.
Change all of them to whatever the brief asks for.

Keep every time, position, colour and word for the film in this file, so the
scene, the sound and the render all read the same values.
"""

# FORMAT (from the brief)
FPS = 30
WIDTH, HEIGHT = 1920, 1080
SECONDS = 5
FRAMES = FPS * SECONDS

# EVENTS: name -> frame. Add whatever this film needs.
EVENTS = {}

# Add anything else the film needs below: colours, words, positions,
# camera keys, sound cues. Name things after what they are in the brief.


def hex_to_rgb(h):
    """Hex colour to linear RGB for Blender materials."""
    h = h.lstrip("#")
    srgb = [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]
    return tuple(c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4 for c in srgb)
