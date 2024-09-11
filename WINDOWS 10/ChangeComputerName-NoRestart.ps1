<#
.SYNOPSIS
  Changes the computer name by updating relevant registry entries.

.DESCRIPTION
  This script prompts the user for a new computer name and updates the necessary registry entries to reflect the change. It removes old computer name properties and sets new ones in various locations.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  User input for the new computer name.

.OUTPUTS
  Updates registry settings related to the computer name.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  01/04/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Ensure the script is run with administrative privileges to modify the registry.

.EXAMPLE
  Run the script and enter the new computer name when prompted. The script will update the registry settings accordingly.

#>

#START OF SCRIPT

# Prompt the user for the new computer name
$ComputerName = Read-Host "Enter the new computer name"

# Remove old properties
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Hostname" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "NV Hostname" -ErrorAction SilentlyContinue

# Set new properties
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" -Name "ComputerName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" -Name "ComputerName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Hostname" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "NV Hostname" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AltDefaultDomainName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Value $ComputerName

#END OF SCRIPT
