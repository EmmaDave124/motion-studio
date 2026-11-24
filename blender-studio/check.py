"""
check.py: review tools.

  python3 check.py contact renders/stills    -> contact_sheet.png (grid of all stills)
  python3 check.py scan renders/full         -> lists missing, blank or broken frames
                                                 and prints the --frames string to re-render them
"""
import glob
import os
import subprocess
import sys

import timeline as T


def contact(folder):
    files = sorted(glob.glob(os.path.join(folder, "f_*.png")))
    if not files:
        sys.exit("no frames in " + folder)
    cols = 6
    rows = (len(files) + cols - 1) // cols
    listfile = os.path.join(folder, "_list.txt")
    with open(listfile, "w") as fh:
        for p in files:
            fh.write(f"file '{os.path.abspath(p).replace(os.sep, '/')}'\n")
    out = os.path.join(folder, "contact_sheet.png")
    subprocess.run([
        "ffmpeg", "-y", "-loglevel", "error", "-f", "concat", "-safe", "0", "-i", listfile,
        "-vf", f"scale=480:-1,drawtext=text='%{{n}}':x=10:y=10:fontcolor=white:fontsize=20,tile={cols}x{rows}:padding=4",
        "-frames:v", "1", out,
    ], check=False)
    if not os.path.exists(out):  # drawtext missing in some builds
        subprocess.run([
            "ffmpeg", "-y", "-loglevel", "error", "-f", "concat", "-safe", "0", "-i", listfile,
            "-vf", f"scale=480:-1,tile={cols}x{rows}:padding=4", "-frames:v", "1", out,
        ], check=True)
    os.remove(listfile)
    print("[check.py] contact sheet:", out)


def scan(folder):
    bad = []
    for f in range(1, T.FRAMES + 1):
        p = os.path.join(folder, f"f_{f:04d}.png")
        if not os.path.exists(p) or os.path.getsize(p) < 2000:
            bad.append(f)
            continue
        r = subprocess.run(
            ["ffmpeg", "-loglevel", "error", "-i", p, "-vf", "signalstats,metadata=print:key=lavfi.signalstats.YAVG", "-f", "null", "-"],
            capture_output=True, text=True,
        )
        if r.returncode != 0:
            bad.append(f)
    if bad:
        print(f"[check.py] {len(bad)} bad or missing frames. Re-render with:")
        print("  --frames " + ",".join(map(str, bad)) + " --force")
    else:
        print(f"[check.py] all {T.FRAMES} frames look good")


if __name__ == "__main__":
    cmd, folder = sys.argv[1], sys.argv[2]
    {"contact": contact, "scan": scan}[cmd](folder)
