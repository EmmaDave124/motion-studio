# One line install for Windows (paste into PowerShell):
#   irm https://raw.githubusercontent.com/EmmaDave124/motion-studio/main/install.ps1 | iex
$Repo = "EmmaDave124/motion-studio"
$Dest = if ($env:MOTION_STUDIO_DIR) { $env:MOTION_STUDIO_DIR } else { Join-Path $HOME "motion-studio" }
if (-not (Test-Path $Dest)) {
  Write-Host "==> Downloading Motion Studio to $Dest" -ForegroundColor Cyan
  $Tmp = Join-Path $env:TEMP ("ms_" + [guid]::NewGuid())
  New-Item -ItemType Directory -Path $Tmp | Out-Null
  Invoke-WebRequest "https://github.com/$Repo/archive/refs/heads/main.zip" -OutFile "$Tmp\studio.zip"
  Expand-Archive "$Tmp\studio.zip" -DestinationPath $Tmp
  Move-Item "$Tmp\motion-studio-main" $Dest
  Remove-Item $Tmp -Recurse -Force
} else {
  Write-Host "==> $Dest already exists, keeping your files" -ForegroundColor Cyan
}
powershell -ExecutionPolicy Bypass -File (Join-Path $Dest "setup-windows.ps1")
