# make.ps1: the Windows version of make.sh. Run inside a film folder:
#   .\make.ps1 scene | stills | full | sound | film | all
param([string]$Step = "all")
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

$Blender = $env:BLENDER
if (-not $Blender) {
  $Blender = (Get-ChildItem "C:\Program Files\Blender Foundation\*\blender.exe" -ErrorAction SilentlyContinue |
              Sort-Object FullName -Descending | Select-Object -First 1).FullName
}
$Py = "python"
foreach ($c in @(".venv\Scripts\python.exe", "..\..\blender-studio\.venv\Scripts\python.exe", "..\blender-studio\.venv\Scripts\python.exe")) {
  if (Test-Path $c) { $Py = (Resolve-Path $c).Path; break }
}
$Frames = & $Py -c "import timeline as T; print(T.FRAMES)"
$Fps = & $Py -c "import timeline as T; print(T.FPS)"

function Scene  { & $Blender -b -P scene.py }
function Stills { & $Blender -b scene.blend -P gpu.py -P render.py -- --frames "1-$($Frames):10" --out renders/stills --half --samples 40 --force
                  & $Py check.py contact renders/stills }
function Full   { & $Blender -b scene.blend -P gpu.py -P render.py -- --frames "1-$Frames" --out renders/full }
function Sound  { & $Py sound.py }
function Film   { & $Py check.py scan renders/full
                  $aud = @(); if (Test-Path build\sound.wav) { $aud = @("-i", "build\sound.wav", "-c:a", "aac", "-b:a", "320k", "-shortest") }
                  ffmpeg -y -framerate $Fps -i renders/full/f_%04d.png @aud -c:v libx264 -profile:v high -crf 17 -pix_fmt yuv420p -movflags +faststart film.mp4
                  Write-Host "Done: $PSScriptRoot\film.mp4" }

switch ($Step) {
  "scene"  { Scene }
  "stills" { Stills }
  "full"   { Full }
  "sound"  { Sound }
  "film"   { Film }
  "all"    { Scene; Stills; Full; Sound; Film }
  default  { Write-Host "usage: .\make.ps1 [scene|stills|full|sound|film|all]" }
}
