# Motion Studio

Make any video from code with Claude: Blender, Remotion and the Herk Edit Kit.
There is no house style. Your brief decides everything. Works on Mac and Windows.

## Install (once)

**Easiest:** open the Claude desktop app and say:
> Set up the Motion Studio from https://github.com/EmmaDave124/motion-studio on my computer.

**Or paste one line yourself.**

Mac (Terminal):
```
curl -fsSL https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.sh | bash
```

Windows (PowerShell):
```
irm https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.ps1 | iex
```

It downloads the studio to a `motion-studio` folder in your home folder, installs
everything it needs (Node, ffmpeg, Python, Blender, Remotion, the Herk Edit Kit, Claude Code)
and renders one plain test frame to prove it works.

## Make a video
Connect the `motion-studio` folder to Claude (desktop app: **+** next to the message box,
then **Add folder**), or run `claude` inside it. Then describe the video in your own words.

## Guides
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
