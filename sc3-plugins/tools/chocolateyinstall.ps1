$ErrorActionPreference = 'Stop'

if (-not [Environment]::Is64BitOperatingSystem) {
  throw 'sc3-plugins 3.14.0 package supports only 64-bit Windows.'
}

$packageName = 'sc3plugins'
$version = '3.14.0'
$url = 'https://github.com/supercollider/sc3-plugins/releases/download/Version-3.14.0/sc3-plugins-3.14.0-Windows-64bit.zip'
$checksum = '603965BC93FECEA3928FB77AC1ACD13825474D2F449134A72AEE3D45257D8561'
$extensionsDir = Join-Path $env:LOCALAPPDATA 'SuperCollider\Extensions'
$pluginsDir = Join-Path $extensionsDir 'SC3plugins'
$legacyInstallDir = Join-Path $extensionsDir 'install'
$legacyPluginsDir = Join-Path $legacyInstallDir 'SC3plugins'
$extractDir = Join-Path $env:TEMP "sc3plugins-$version-extract"

New-Item -ItemType Directory -Path $extensionsDir -Force | Out-Null

if (Test-Path $pluginsDir) {
  Write-Host "Removing existing $pluginsDir"
  Remove-Item -Path $pluginsDir -Recurse -Force
}

if (Test-Path $legacyPluginsDir) {
  Write-Host "Removing legacy nested $legacyPluginsDir"
  Remove-Item -Path $legacyPluginsDir -Recurse -Force
}

if ((Test-Path $legacyInstallDir) -and -not (Get-ChildItem -Path $legacyInstallDir -Force -ErrorAction SilentlyContinue)) {
  Remove-Item -Path $legacyInstallDir -Force
}

if (Test-Path $extractDir) {
  Remove-Item -Path $extractDir -Recurse -Force
}
New-Item -ItemType Directory -Path $extractDir -Force | Out-Null

try {
  Install-ChocolateyZipPackage `
    -PackageName $packageName `
    -Url $url `
    -UnzipLocation $extractDir `
    -Checksum $checksum `
    -ChecksumType 'sha256'

  $sourcePluginsDir = Get-ChildItem -Path $extractDir -Directory -Recurse -Filter 'SC3plugins' |
    Select-Object -First 1

  if (-not $sourcePluginsDir) {
    throw 'sc3-plugins archive did not contain an SC3plugins directory.'
  }

  Write-Host "Installing SC3plugins from $($sourcePluginsDir.FullName) to $pluginsDir"
  Copy-Item -Path $sourcePluginsDir.FullName -Destination $pluginsDir -Recurse -Force

  if (-not (Test-Path $pluginsDir)) {
    throw "sc3-plugins copy completed without creating $pluginsDir."
  }
}
finally {
  if (Test-Path $extractDir) {
    Remove-Item -Path $extractDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}
