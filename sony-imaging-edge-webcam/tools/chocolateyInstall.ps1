﻿$ErrorActionPreference = 'Stop';

$packageName  = 'sony-imaging-edge-webcam'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$fileLocation = Get-ChocolateyWebFile -PackageName 'SonyIEW.exe' -FileFullPath "$toolsDir\SonyIEW.exe" -Url 'https://di.update.sony.net/NEX/ewH5TVuMLU/IEW111_2108a.exe'

# Get publisher certificate from the file and add it to TrustedPublisher
$cert = (Get-AuthenticodeSignature $fileLocation ).SignerCertificate;
$certFile = Join-Path $toolsDir 'Publisher.cer'
$exportType = [Security.Cryptography.X509Certificates.X509ContentType]::Cert;
[IO.File]::WriteAllBytes($certFile, $cert.Export($exportType));
certutil.exe -addstore -f TrustedPublisher $certFile

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'Imaging Edge Webcam'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/quiet"
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs