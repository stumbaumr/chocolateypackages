$ErrorActionPreference = 'Stop';

$packageName  = 'sony-imaging-edge-webcam'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$webFileArgs = @{
  packageName   = $packageName
  FileFullPath  = "$toolsDir\SonyIEW.exe"
  Url           = 'https://di.update.sony.net/NEX/ewH5TVuMLU/IEW111_2108a.exe'  
  Checksum      = '2026AF500609738B19ED5B9B73FE72A995B7478133CACC4E4E15537D83D91327'
  ChecksumType  = 'sha256'
}

$fileLocation = Get-ChocolateyWebFile @webFileArgs

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
