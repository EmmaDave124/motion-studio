"""
sound.py: the soundtrack for ONE film.

Blank starter: it writes silence the length of the film. Replace the middle with
whatever the brief asks for: music and effects made in code and timed from
timeline.py, the user's own music or voiceover files, or both.

Keep the finish() step: it rolls off harsh highs and sets a -1 dB true-peak
ceiling so the audio doesn't crackle on phones.

Run: python3 sound.py   ->  build/sound.wav
"""
import os

import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, resample_poly, sosfilt

import timeline as T

SR = 48000
N = int(SR * T.FRAMES / T.FPS)


def finish(mix):
    """High roll-off and -1 dBTP ceiling (measured at 4x oversampling)."""
    mix = sosfilt(butter(2, 15000, "lp", fs=SR, output="sos"), mix)
    peak = np.max(np.abs(resample_poly(mix, 4, 1)))
    if peak > 0:
        mix = mix * (10 ** (-1 / 20)) / peak
    return mix


mix = np.zeros(N)

# Build the soundtrack here, from the brief.

mix = finish(mix)
os.makedirs("build", exist_ok=True)
wavfile.write("build/sound.wav", SR, (np.stack([mix, mix], axis=1) * 32767).astype(np.int16))
print(f"[sound.py] wrote build/sound.wav ({N / SR:.1f}s)")
