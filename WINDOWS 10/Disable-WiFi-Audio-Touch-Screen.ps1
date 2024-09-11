<#
.SYNOPSIS
  Disables wireless adapters, Bluetooth, audio devices, and touch screen devices.
.DESCRIPTION
  This script disables Wi-Fi and Bluetooth adapters, onboard audio devices, and touch screens if they are present on the system.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Review device names and classes to ensure accurate targeting.

.EXAMPLE
  Run this script to disable specified hardware components on the local machine.
#>

# Disabled Wi-Fi and Bluetooth adapters
Get-NetAdapter | ForEach-Object { 
    if ($_.Name -like "*Wi*Fi*" -or $_.Description -like "*Wireless*") {
        # Disable Wi-Fi adapters
        Disable-NetAdapter -Name $_.Name -Confirm:$false
        Write-Output "$($_.Name), $($_.Status)"
    }
    elseif ($_.Name -like "*Bluetooth*" -or $_.Description -like "*Bluetooth*") {
        # Disable Bluetooth adapters
        Write-Output "Disabling Bluetooth"
        Disable-NetAdapter -Name $_.Name -Confirm:$false
    }
}

# Disable onboard audio devices
$audioDevices = Get-PnpDevice | Where-Object { 
    ($_.Class -eq 'MEDIA' -and $_.Name -like '*Display*Audio*') -or 
    ($_.Class -eq 'MEDIA' -and $_.Name -like '*synaptics*') 
}
if ($audioDevices) {
    foreach ($device in $audioDevices) {
        Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
        Write-Host "Onboard speakers disabled: $($device.FriendlyName)"
    }
} else {
    Write-Host "No onboard speakers found."
}

# Disable touch screen devices
Get-PnpDevice | Where-Object { $_.FriendlyName -like '*touch screen*' } | Disable-PnpDevice -Confirm:$false

# Pause execution for 3 seconds
Timeout 3
