<#
.SYNOPSIS
  Adds a specified IP address and hostname entry to the local hosts file.
.DESCRIPTION
  This script checks if the provided IP address and hostname entry already exists in the hosts file. If the entry does not exist, it appends the new entry. If it already exists, the script informs the user.
.PARAMETER None
    No parameters are required for this script. The IP address and hostname are specified within the script.
.INPUTS
  None
.OUTPUTS
  Updates the hosts file with the specified IP address and hostname if the entry does not already exist.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  19 June 2022
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in an elevated PowerShell session. The script will check for the entry and add it to the hosts file if necessary.
#>

# START OF SCRIPT

# DEFINE THE DEMO IP ADDRESS AND HOSTNAME
$ipAddress = "192.168.1.1"
$hostname = "example.com"

# DEFINE THE PATH TO THE HOSTS FILE
$hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"

# CHECK IF THE SCRIPT IS RUNNING WITH ELEVATED PRIVILEGES (AS ADMINISTRATOR)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run the script as an administrator."
    exit
}

# CHECK IF THE ENTRY ALREADY EXISTS IN THE HOSTS FILE
$existingEntry = Get-Content $hostsFilePath | Where-Object { $_ -match "^$ipAddress\s+$hostname" }

if ($existingEntry -eq $null) {
    # APPEND THE NEW ENTRY TO THE HOSTS FILE
    Add-Content -Path $hostsFilePath -Value "$ipAddress`t$hostname"
    Write-Host "Entry added to hosts file: $ipAddress $hostname"
} else {
    Write-Host "Entry already exists in hosts file."
}

# END OF SCRIPT
