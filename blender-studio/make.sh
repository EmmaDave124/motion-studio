#!/usr/bin/env bash
# make.sh: the render pipeline for one film. Copy this folder into films/<name>/ for each video.
#   ./make.sh scene     build scene.blend from timeline.py
#   ./make.sh stills    18 half-size stills + contact sheet (check these first!)
#   ./make.sh full      render all frames on the GPU (resumable)
#   ./make.sh sound     synthesize build/sound.wav
#   ./make.sh film      scan frames, then encode film.mp4 with sound
#   ./make.sh all       everything, in order
set -euo pipefail
cd "$(dirname "$0")"

BLENDER="${BLENDER:-blender}"
if ! command -v "$BLENDER" >/dev/null 2>&1 && [ -x /Applications/Blender.app/Contents/MacOS/Blender ]; then
  BLENDER=/Applications/Blender.app/Contents/MacOS/Blender
fi
PY=python3
[ -x .venv/bin/python3 ] && PY=.venv/bin/python3
FRAMES=$("$PY" -c "import timeline as T; print(T.FRAMES)")
FPS=$("$PY" -c "import timeline as T; print(T.FPS)")

scene()  { "$BLENDER" -b -P scene.py; }
stills() { "$BLENDER" -b scene.blend -P gpu.py -P render.py -- --frames "1-${FRAMES}:10" --out renders/stills --half --samples 40 --force
           "$PY" check.py contact renders/stills; }
full()   { "$BLENDER" -b scene.blend -P gpu.py -P render.py -- --frames "1-${FRAMES}" --out renders/full; }
sound()  { "$PY" sound.py; }
film()   { "$PY" check.py scan renders/full
           if [ -f build/sound.wav ]; then AUD=(-i build/sound.wav -c:a aac -b:a 320k -shortest); else AUD=(); fi
           ffmpeg -y -framerate "$FPS" -i renders/full/f_%04d.png "${AUD[@]}" \
             -c:v libx264 -profile:v high -crf 17 -pix_fmt yuv420p -movflags +faststart film.mp4
           echo "Done: $(pwd)/film.mp4"; }

case "${1:-all}" in
  scene) scene ;; stills) stills ;; full) full ;; sound) sound ;; film) film ;;
  all) scene; stills; full; sound; film ;;
  *) echo "usage: ./make.sh [scene|stills|full|sound|film|all]"; exit 1 ;;
esac
