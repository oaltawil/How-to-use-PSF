#
# 1. Prepare the environment: Always run this block of code first to set up the environment.
#

$PackageFullName = "OneCommander_3.80.2.0_x64__xt0cqksxvfzh2"

$AppPath           = Join-Path -Path "C:\PSF\SourceApp" -ChildPath ($PackageFullName + ".msix")     ## Path to the MSIX App Installer
$StagingFolderPath = Join-Path -Path "C:\PSF\Staging" -ChildPath $PackageFullName                   ## Path to where the MSIX App will be staged
$OSArchitecture    = "x$((Get-CimInstance Win32_Processor).AddressWidth)"                           ## Operating System Architecture
$Win10SDKVersion   = "10.0.26100.0"                                                                 ## Latest version of the Windows 11 SDK

# Set the directory to the Windows 10 SDK
Set-Location "${env:ProgramFiles(x86)}\Windows Kits\10\Bin\$Win10SDKVersion\$OSArchitecture"

#
# 2. Stage or unpack the package
#

# Create the Staging folder if it does not exist
if (-not (Test-Path $StagingFolderPath)) {

    New-Item -Path $StagingFolderPath -ItemType Directory -Force | Out-Null

}

# Unpackage the Windows app to the staging folder
.\makeappx.exe unpack /p "$AppPath" /d "$StagingFolderPath"

#
# 3. Edit the package and apply the fixes
#

    # a. Add the PSF binaries
    # b. Create the config.json, which defines the PSF fix-ups
    # c. Edit the AppxManifest.xml to launch PsfLauncher

#
# 4. Test the application by installing it directly from the staged folder - rather than creating, signing, and installing a package
#

$manifestPath = Join-Path -Path $StagingFolderPath -ChildPath "AppxManifest.xml"

Add-AppxPackage -Path $manifestPath -Register

#
# 5. Repackage and re-sign the application
#

$CodeSigningCert   = "C:\PSF\Certificates\Self-Signed Code Signing Certificate.pfx"             ## Path to your code signing certificate
$CodeSigningPass   = 'poltis'                                                                   ## Password used by the code signing certificate

.\makeappx.exe pack /p "$AppPath" /d "$StagingFolderPath" /o

.\signtool.exe sign /v /fd sha256 /f "$CodeSigningCert" /p "$CodeSigningPass" /t "http://timestamp.digicert.com" "$AppPath"