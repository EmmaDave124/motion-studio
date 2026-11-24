#!/usr/bin/env bash
# One line install for Mac:
#   curl -fsSL https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.sh | bash
set -euo pipefail
REPO="EmmaDave124/motion-studio"
DEST="${MOTION_STUDIO_DIR:-$HOME/motion-studio}"
if [ ! -d "$DEST" ]; then
  echo "==> Downloading Motion Studio to $DEST"
  TMP="$(mktemp -d)"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.zip" -o "$TMP/studio.zip"
  unzip -q "$TMP/studio.zip" -d "$TMP"
  mv "$TMP"/motion-studio-main "$DEST"
  rm -rf "$TMP"
else
  echo "==> $DEST already exists, keeping your files"
fi
cd "$DEST"
bash setup-mac.sh
