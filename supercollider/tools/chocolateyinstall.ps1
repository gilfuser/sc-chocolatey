$ErrorActionPreference = 'Stop'

if (-not [Environment]::Is64BitOperatingSystem) {
  throw 'SuperCollider 3.14.1 package supports only 64-bit Windows.'
}

$packageName = 'supercollider'
$version = '3.14.1'
$url = 'https://github.com/supercollider/supercollider/releases/download/Version-3.14.1/SuperCollider-3.14.1_Release-x64-VS-426edf6.exe'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url            = $url
  softwareName   = "SuperCollider Version $version"
  checksum       = 'EBB27352978539AD5D0E8BB6707CEE10C3C59ABCD9ACB0C2B2D6221081396F30'
  checksumType   = 'sha256'
  validExitCodes = @(0, 3010, 1641)
  silentArgs     = '/S'
}

Install-ChocolateyPackage @packageArgs
