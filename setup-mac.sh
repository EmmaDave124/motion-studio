#!/usr/bin/env bash
# One time setup for the EmmaDave Motion Studio on macOS (Apple Silicon).
# Run from inside this folder:   bash setup-mac.sh
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$(pwd)"
say() { printf "\n\033[1;36m==> %s\033[0m\n" "$1"; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  for b in /opt/homebrew/bin/brew "$HOME/.homebrew/bin/brew" /usr/local/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
  done
fi
if ! command -v brew >/dev/null 2>&1; then
  say "Installing Homebrew (it will ask for your Mac password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Tools: Node 22+, full ffmpeg, Python, git, Blender
say "Installing Node, ffmpeg, Python and git"
brew install node ffmpeg python@3.12 git || true
NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
if [ "$NODE_MAJOR" -lt 22 ]; then brew upgrade node; fi

if [ ! -d /Applications/Blender.app ]; then
  say "Installing Blender"
  brew install --cask blender
fi
BLENDER=/Applications/Blender.app/Contents/MacOS/Blender
if ! grep -q 'Blender.app/Contents/MacOS' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="/Applications/Blender.app/Contents/MacOS:$PATH"' >> "$HOME/.zshrc"
  echo 'alias blender=/Applications/Blender.app/Contents/MacOS/Blender' >> "$HOME/.zshrc"
fi

# 3. Python sound libraries in a private venv (avoids macOS pip errors)
say "Setting up Python sound libraries"
"$(brew --prefix python@3.12)/bin/python3.12" -m venv "$ROOT/blender-studio/.venv"
"$ROOT/blender-studio/.venv/bin/pip" install -q --upgrade pip
"$ROOT/blender-studio/.venv/bin/pip" install -q numpy scipy pedalboard

# 4. Remotion project
say "Installing Remotion"
(cd "$ROOT/remotion-studio" && npm install --no-audit --no-fund)

# 5. Herk Edit Kit (HyperFrames + editing skills for Claude Code)
say "Installing Herk Edit Kit"
if [ ! -d "$ROOT/herk-edit-kit" ]; then
  git clone https://github.com/nateherkai/herk-edit-kit.git "$ROOT/herk-edit-kit"
fi
(cd "$ROOT/herk-edit-kit" && npm ci && npm run setup && npm test) || echo "Herk kit finished with warnings, see above"

# 6. Claude Code
if ! command -v claude >/dev/null 2>&1; then
  say "Installing Claude Code"
  npm install -g @anthropic-ai/claude-code
fi

# 7. Smoke test: build the Blender scene and render one still on the Mac GPU (Metal)
say "Testing Blender on your GPU"
(cd "$ROOT/blender-studio" && "$BLENDER" -b -P scene.py >/dev/null \
  && "$BLENDER" -b scene.blend -P gpu.py -P render.py -- --frames 1 --out renders/test --half --samples 32 --force \
  | grep -E "gpu.py|render.py")

say "All set!"
echo "Open a NEW terminal window, then:"
echo "  cd \"$ROOT\" && claude"
echo "and describe the video you want, in your own words."
open "$ROOT/blender-studio/renders/test/f_0001.png" 2>/dev/null || true
