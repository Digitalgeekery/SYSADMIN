<#
.SYNOPSIS
  Exports PC information including desk number, hostname, MAC address, serial number, and make/model to a text file.
.DESCRIPTION
  This script collects and exports information about the PC including the desk number, hostname, MAC address, serial number, and make/model. It maps a network drive for saving the file and then removes the mapped drive.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  A text file containing the PC information is saved to a specified network location.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None
.EXAMPLE
  .\Export-PCInfo.ps1
#>

Write-Host "==================================================================" -ForegroundColor Green
Write-Host "================         EXPORTING PC INFO        ===============" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green

Write-Host "==================================================================" -ForegroundColor Green
Write-Host "================             PC DESK NO           ===============" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Output ""
Write-Output ""

# Collecting PC desk number
$DeskNo = Read-Host -Prompt "ENTER THE DESK NUMBER OF PC"

Get-NetAdapter
$nicno = Read-Host -Prompt "ENTER NETWORK INDEX NUMBER"

# Credentials for export
$Username = "your_domain\your_username"  # Replace with actual username
$password = "your_password"  # Replace with actual password
$secPassword = ConvertTo-SecureString $password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential ($Username, $secPassword)

# Get date and time
$date = Get-Date

# Get hostname
$hostname = $env:computername

# Get MAC address
$adapters = (Get-NetAdapter -InterfaceIndex $nicno).MacAddress.Replace('-', '')

# Get serial number
$serial = (Get-WmiObject win32_bios).SerialNumber

# Get make and model
$mmakemodel = Get-WMIObject -Class Win32_ComputerSystem | Select-Object -Property Manufacturer, Model

# Export to text file
$Results = [PSCustomObject]@{
    "Date Exported"     = $date
    "PC Desk No"        = $DeskNo
    "Hostname"          = $hostname
    "Serial No"         = $serial
    "Network Info"      = $adapters
    "PC Make & Model"   = "$($mmakemodel.Manufacturer) $($mmakemodel.Model)"
}

$Results | Out-File -FilePath "C:\$hostname.txt"

# Prompt output
Write-Host "FILE EXPORTED" -ForegroundColor Green
Start-Sleep -Seconds 3
