<#
.SYNOPSIS
  Retrieves the firmware-embedded product key and activates Windows with this key.
.DESCRIPTION
  This script extracts the firmware-embedded product key from the system, installs it using the Windows Script Host, and activates Windows. It also checks the product key channel to ensure activation was successful.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  Outputs messages indicating the success or failure of retrieving the product key, installing it, activating Windows, and verifying the product key channel.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Ensure the script is run with administrative privileges for activation.

.EXAMPLE
  .\Activate-WindowsWithFirmwareKey.ps1
#>

# Start Transcript
$Transcript = "C:\programdata\Microsoft\IntuneManagementExtension\Logs\$($(Split-Path $PSCommandPath -Leaf).ToLower().Replace('.ps1','.log'))"
Start-Transcript -Path $Transcript | Out-Null

# Get firmware-embedded product key
try {
    $EmbeddedKey = (Get-CimInstance -Query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
    Write-Host "Firmware-embedded product key is $EmbeddedKey"
} catch {
    Write-Host "ERROR: Failed to retrieve firmware-embedded product key"
    Exit 1
}

# Install embedded key
try {
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk "$EmbeddedKey"
    Write-Host "Installed license key"
} catch {
    Write-Host "ERROR: Changing license key failed"
    Exit 2
}

# Activate embedded key
try {
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato
    Write-Host "Windows activated"
} catch {
    Write-Host "ERROR: Windows could not be activated."
    Exit 3
}

# Check Product Key Channel
$getreg = Get-WmiObject SoftwareLicensingProduct -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f' and LicenseStatus = '1'"
$ProductKeyChannel = $getreg.ProductKeyChannel

if ($ProductKeyChannel -eq "OEM:DM") {
    Write-Host "Windows activated, ProductKeyChannel = $ProductKeyChannel"
    Exit 0
} else {
    Write-Host "ERROR: Windows could not be activated. $ProductKeyChannel"
    Exit 4
}

Stop-Transcript
