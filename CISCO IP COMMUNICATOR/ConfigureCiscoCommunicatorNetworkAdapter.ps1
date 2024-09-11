<#
.SYNOPSIS
  Configures network adapter settings for a Cisco Communicator application.

.DESCRIPTION
  This script retrieves network adapter details and updates specific registry keys with information about the selected network adapter. It prompts the user to enter the WiFi index number and updates the "HostName" and "NetworkCurrentAdapter" values in the registry.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  User input for WiFi index number.

.OUTPUTS
  Updates registry settings for the Cisco Communicator application based on the selected network adapter.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  25/09/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None

.EXAMPLE
  Run the script and enter the WiFi index number when prompted. The script will update the registry settings for the Cisco Communicator application based on the selected network adapter.

#>

#START OF SCRIPT

Write-Output "";
Get-NetAdapter
Write-Output "";
Write-Output "";
Write-Host "================ POINTING PHONE NIC ================" -ForegroundColor GREEN
$nicno = Read-Host -Prompt "ENTER WIFI INDEX NUMBER"

Set-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -name "HostName" -value "SEP$((Get-NetAdapter -InterfaceIndex $nicno).MacAddress.Replace('-',''))"
Set-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -name "NetworkCurrentAdapter" -Value (Get-NetAdapter -InterfaceIndex $nicno).Name

#END OF SCRIPT
