$ErrorActionPreference = 'Stop'

$pluginsDir = Join-Path $env:LOCALAPPDATA 'SuperCollider\Extensions\SC3plugins'
$legacyInstallDir = Join-Path $env:LOCALAPPDATA 'SuperCollider\Extensions\install'
$legacyPluginsDir = Join-Path $legacyInstallDir 'SC3plugins'

if (Test-Path $pluginsDir) {
  Write-Host "Removing $pluginsDir"
  Remove-Item -Path $pluginsDir -Recurse -Force
}

if (Test-Path $legacyPluginsDir) {
  Write-Host "Removing legacy nested $legacyPluginsDir"
  Remove-Item -Path $legacyPluginsDir -Recurse -Force
}

if ((Test-Path $legacyInstallDir) -and -not (Get-ChildItem -Path $legacyInstallDir -Force -ErrorAction SilentlyContinue)) {
  Remove-Item -Path $legacyInstallDir -Force
}
