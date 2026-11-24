# Motion Studio

This folder makes videos from code. Claude does not generate video: it writes
programs that describe every frame, then renders them.

## The one rule: the user's brief decides everything

There is NO house style. No default look, colours, fonts, characters, camera moves,
music, pacing, length, aspect ratio or engine. Do exactly what the user describes,
even if it breaks every convention in this folder.

- Never fall back on earlier films, starter files or outside guides for style. They show
  how the tools work, not how videos should look.
- If the brief leaves something open and it matters, ask one short question.
  If the user isn't around, choose what fits their brief best and say what you chose.
- If the user's own instructions or saved preferences conflict with this file, theirs win.
- Any tool is allowed. Use Blender, Remotion, the Herk Edit Kit, plain Three.js,
  ffmpeg, Python, real footage, the user's images and clips, or anything else that
  gets the result they described. Install what's needed.

## Tools available in this folder

| Folder | What it gives you |
|---|---|
| `blender-studio/` | Blender (Cycles) tools: `gpu.py` picks the fastest render device, `render.py` renders any frame range and skips finished frames, `check.py` makes contact sheets and finds broken frames, `make.sh` runs the steps. `timeline.py`, `scene.py` and `sound.py` are BLANK starters (a grey test sphere and silence): replace them completely for each film. |
| `remotion-studio/` | A blank Remotion project (React, with Three.js available for 3D). `src/Main.tsx` is empty: build the video there. |
| `herk-edit-kit/` | HyperFrames editing kit for real footage, captions and reels. Has its own CLAUDE.md and skills. |
| `films/` | One folder per video. Any earlier films in here belong to their own briefs: never copy their style unless asked. |

Do not follow any outside template, guide or earlier film as a pattern for format, length,
tempo, story, camera, look or tools. Use outside guides only for technique.

## Machine notes
- Mac: Blender at `/Applications/Blender.app/Contents/MacOS/Blender`; Cycles uses METAL
  on Apple Silicon. Run steps with `./make.sh`.
- Windows: Blender path is in the `BLENDER` environment variable (set by setup-windows.ps1).
  Run steps with `.\make.ps1` in PowerShell. NVIDIA uses OPTIX/CUDA, AMD uses HIP.
- Python libs for sound live in `blender-studio/.venv` on both.
- Pass `gpu.py` on every Blender render (the GPU choice isn't saved in the .blend file).

## Working practices (these protect quality, not style)
- Build each film in its own folder under `films/`.
- Keep times and positions in one place (a timeline file or constants) so changes are cheap.
- Check your own work before handing it over: render a few stills and look at them.
- Before a long render, show the user a quick low resolution preview VIDEO with sound
  (not just stills) unless they said to go straight to the final.
- Render final quality on the user's own computer when possible; it costs no Claude usage.

## Known technical fixes
- Remotion can't download its browser: add `--browser-executable=<path to Chrome>`.
- Fonts: install with npm (`@fontsource/<font>`) and import the CSS so renders don't need the internet.
- Text behind glossy surfaces reflects and looks broken: lift it clear.
- Blender colours look washed out under AgX: lower exposure, darken base colours.
- White blocks on glass: set `visible_glossy = False` on lights.
- Objects in the wrong place: call `view_layer.update()` before parenting.
- Audio for phones: keep a -1 dBTP true-peak ceiling.
- Quick preview: `render.py --pct 40 --samples 8`.
