<#
.SYNOPSIS
  Exports system information to a text file.
.DESCRIPTION
  This script gathers system details such as the logged-in user, hostname, MAC address, serial number, and PC make & model. The gathered information is then exported to a text file in a specified network location.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  A text file containing the system information at a specified network location.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  08/03/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None
.EXAMPLE
  .\Export-SystemInfo.ps1
#>

# Credentials for export
$Username = "your_domain\your_username"  # Replace with actual username
$password = "your_password"  # Replace with actual password
$secPassword = ConvertTo-SecureString $password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential ($Username, $secPassword)

# Get the logged-in user
$user = (Get-CimInstance -ClassName Win32_ComputerSystem).Username

# Get the date and time
$date = Get-Date

# Get the hostname
$hostname = $env:computername

# Get the MAC address
$adapters = (Get-NetAdapter -Name Wi-Fi | Where-Object Status -eq 'Up').MacAddress.Replace('-', '')

# Get the serial number
$serial = (Get-WmiObject win32_bios).SerialNumber

# Get make and model
$mmakemodel = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property Manufacturer, Model

# Export results to text file
$Results = [PSCustomObject]@{
    "Date Exported"      = $date
    "User Logged In"     = $user
    "Hostname"           = $hostname
    "Serial No"          = $serial
    "Network Info"       = $adapters
    "PC Make & Model"    = "$($mmakemodel.Manufacturer) $($mmakemodel.Model)"
}

# Pushing results out
$Results | Out-File -FilePath "c:\$hostname.txt"

# Prompt out
Write-Host "FILE EXPORTED - PC CHECK IN COMPLETED" -ForegroundColor Green
