# One time setup for the Motion Studio on Windows 10 or 11.
# Run from inside this folder, in PowerShell:
#   powershell -ExecutionPolicy Bypass -File .\setup-windows.ps1
$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

function Say($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
              [Environment]::GetEnvironmentVariable("Path", "User")
}

# 1. Tools via winget (built into Windows 10 and 11)
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget is missing. Install 'App Installer' from the Microsoft Store, then run this again." -ForegroundColor Red
  exit 1
}
Say "Installing Node, ffmpeg, Python, Git and Blender (Windows may ask for permission)"
$pkgs = @("OpenJS.NodeJS.LTS", "Gyan.FFmpeg", "Python.Python.3.12", "Git.Git", "BlenderFoundation.Blender")
foreach ($p in $pkgs) {
  winget install --id $p -e --silent --accept-package-agreements --accept-source-agreements
}
Refresh-Path

# 2. Find Blender
$Blender = (Get-ChildItem "C:\Program Files\Blender Foundation\*\blender.exe" -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending | Select-Object -First 1).FullName
if (-not $Blender) { Write-Host "Blender not found. Install it from blender.org, then run this again." -ForegroundColor Red; exit 1 }
[Environment]::SetEnvironmentVariable("BLENDER", $Blender, "User")
$env:BLENDER = $Blender
Write-Host "Blender: $Blender"

# 3. Python sound libraries in a private venv
Say "Setting up Python sound libraries"
$py = (Get-Command py -ErrorAction SilentlyContinue)
if ($py) { py -3.12 -m venv "$Root\blender-studio\.venv" } else { python -m venv "$Root\blender-studio\.venv" }
& "$Root\blender-studio\.venv\Scripts\python.exe" -m pip install -q --upgrade pip
& "$Root\blender-studio\.venv\Scripts\python.exe" -m pip install -q numpy scipy pedalboard

# 4. Remotion project
Say "Installing Remotion"
Push-Location "$Root\remotion-studio"; npm install --no-audit --no-fund; Pop-Location

# 5. Herk Edit Kit
Say "Installing Herk Edit Kit"
if (-not (Test-Path "$Root\herk-edit-kit")) {
  git clone https://github.com/nateherkai/herk-edit-kit.git "$Root\herk-edit-kit"
}
Push-Location "$Root\herk-edit-kit"
npm ci; npm run setup
if ($LASTEXITCODE -ne 0) { Write-Host "Herk kit finished with warnings, see above" -ForegroundColor Yellow }
Pop-Location

# 6. Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Say "Installing Claude Code"
  npm install -g @anthropic-ai/claude-code
}

# 7. Smoke test: one plain test frame
Say "Testing Blender"
Push-Location "$Root\blender-studio"
& $Blender -b -P scene.py | Out-Null
& $Blender -b scene.blend -P gpu.py -P render.py -- --frames 1 --out renders/test --half --samples 32 --force |
  Select-String "gpu.py|render.py"
Pop-Location

Say "All set!"
Write-Host "Open a NEW PowerShell window, then:"
Write-Host "  cd `"$Root`"; claude"
Write-Host "and describe the video you want, in your own words."
Start-Process "$Root\blender-studio\renders\test\f_0001.png" -ErrorAction SilentlyContinue
