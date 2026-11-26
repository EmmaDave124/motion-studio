# Motion Studio

Make any video from code with Claude: Blender, Remotion and the Herk Edit Kit.
There is no house style. Your brief decides everything. Works on Mac and Windows.

## Install (once)

1. Download and install the **Claude desktop app**: https://claude.ai/download (sign in, paid plan).
2. Open **Terminal** (Mac: Cmd + Space, type Terminal) or **PowerShell** (Windows: Windows key, type PowerShell).
3. Paste the line for your computer and press Enter.

Mac (Terminal):
```
curl -fsSL https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.sh | bash
```

Windows (PowerShell):
```
irm https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.ps1 | iex
```

It creates a `motion-studio` folder in your home folder, installs everything it needs
(Node, ffmpeg, Python, Blender, Remotion, the Herk Edit Kit, Claude Code)
and opens a plain grey test image when it's done.

4. In the Claude app, click **Project or folder** under the message box, then **Add folder**,
   and choose `motion-studio`.

## Make a video
In that chat, describe the video in your own words: what it's for, the look, what happens,
the words, the sound and the format. Put your logo, photos and clips in the `motion-studio`
folder and tell Claude their names.

## Guides
- `docs/Quick Start.pdf`: the step by step setup with screenshots. Start here
- `docs/Setup Guide.pdf`: every step, both systems, and every problem we hit
- `docs/The Method.pdf`: how videos get made, for any style

## Folder map
- `CLAUDE.md` how Claude works here. Main rule: your brief decides everything
- `BRIEF_TEMPLATE.md` optional prompts for writing a brief
- `blender-studio/` Blender tools and blank starters (`make.sh` on Mac, `make.ps1` on Windows)
- `remotion-studio/` a blank Remotion project
- `films/` one folder per video
- `herk-edit-kit/` downloaded by setup, for editing real footage

Built by EmmaDave Systems. The method grew from Nate Herk's Claude + Blender guide.
