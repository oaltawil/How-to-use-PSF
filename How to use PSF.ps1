#
# 1. Stage or unpack the folder
#

$PackageFullName = "Fiserv.InboundReturnsExpress.TD-CAT_5.6.1.0_x64__xt0cqksxvfzh2"

$AppPath           = Join-Path -Path "C:\PSF\SourceApp" -ChildPath ($PackageFullName + ".msix")     ## Path to the MSIX App Installer
$StagingFolderPath = Join-Path -Path "C:\PSF\Staging" -ChildPath $PackageFullName                   ## Path to where the MSIX App will be staged
$OSArchitecture    = "x$((Get-CimInstance Win32_Processor).AddressWidth)"                           ## Operating System Architecture
$Win10SDKVersion   = "10.0.26100.0"                                                                 ## Latest version of the Windows 11 SDK

# Create the Staging folder if it does not exist
if (-not (Test-Path $StagingFolderPath)) {

    New-Item -Path $StagingFolderPath -ItemType Directory -Force | Out-Null

}

# Set the directory to the Windows 10 SDK
Set-Location "${env:ProgramFiles(x86)}\Windows Kits\10\Bin\$Win10SDKVersion\$OSArchitecture"

# Unpackage the Windows app to the staging folder
.\makeappx.exe unpack /p "$AppPath" /d "$StagingFolderPath"

#
# 2. Edit the package and apply the fixes
#

    # a. Add the PSF binaries
    # b. Create the config.json, which defines the PSF fix-ups
    # c. Edit the AppxManifest.xml to launch PsfLauncher

#
# 3. Test the application by installing it directly from the staged folder - rather than creating, signing, and installing a package
#

$manifestPath = Join-Path -Path $StagingFolderPath -ChildPath "AppxManifest.xml"

Add-AppxPackage -Path $manifestPath -Register

#
# 4. Repackage and re-sign the application
#

$PackageFullName = "Fiserv.InboundReturnsExpress.TD-CAT_5.6.1.0_x64__xt0cqksxvfzh2"

$AppPath           = Join-Path -Path "C:\PSF\SourceApp" -ChildPath ($PackageFullName + ".msix")     ## Path to the MSIX App Installer
$StagingFolderPath = Join-Path -Path "C:\PSF\Staging" -ChildPath $PackageFullName                   ## Path to where the MSIX App will be staged
$OSArchitecture    = "x$((Get-CimInstance Win32_Processor).AddressWidth)"                           ## Operating System Architecture
$Win10SDKVersion   = "10.0.26100.0"                                                                 ## Latest version of the Win10 SDK

$CodeSigningCert   = "C:\PSF\Certificates\Self-Signed Code Signing Certificate.pfx"             ## Path to your code signing certificate
$CodeSigningPass   = 'poltis'                                                                   ## Password used by the code signing certificate

Set-Location "${env:ProgramFiles(x86)}\Windows Kits\10\Bin\$Win10SDKVersion\$OSArchitecture"

.\makeappx.exe pack /p "$AppPath" /d "$StagingFolderPath" /o

.\signtool.exe sign /v /fd sha256 /f "$CodeSigningCert" /p "$CodeSigningPass" /t "http://timestamp.digicert.com" "$AppPath"