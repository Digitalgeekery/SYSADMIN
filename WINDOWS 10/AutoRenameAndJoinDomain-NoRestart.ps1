<#
.SYNOPSIS
  Renames the computer, adds it to a domain, and updates group policies.

.DESCRIPTION
  This script allows users to rename a computer, apply the new name to the necessary registry entries, and add the computer to a specified domain. It also forces a group policy update to ensure changes are applied.

.PARAMETER None
    This script does not require parameters but prompts for user input.

.INPUTS
  Prompts for the new computer name, domain credentials, and domain OU path.

.OUTPUTS
  Updates the registry settings and domain information for the computer.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  15/08/2021
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Script should be run with administrative privileges.
  TODO:           Implement additional error handling and logging.

.EXAMPLE
  Run the script and follow the prompts to rename the computer and join it to the domain.
#>

# START OF SCRIPT

# DISPLAY HEADER FOR RENAMING THE COMPUTER
Write-Host "==================================================================" -ForegroundColor GREEN
Write-Host "================           RENAMING PC            ================" -ForegroundColor GREEN
Write-Host "==================================================================" -ForegroundColor GREEN
Write-Output ""
Write-Output ""

# Prompt the user for the new computer name
$ComputerName = Read-Host "Enter the new computer name"

# Remove old properties
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Hostname"
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "NV Hostname"

# Set new properties
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" -Name "ComputerName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" -Name "ComputerName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Hostname" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "NV Hostname" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AltDefaultDomainName" -Value $ComputerName
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Value $ComputerName

# FORCE A GROUP POLICY UPDATE TO ENSURE THE CHANGES ARE APPLIED
gpupdate /FORCE
timeout 3

# DISPLAY HEADER FOR ADDING TO DOMAIN
Write-Output ""
Write-Output ""
Write-Host "==================================================================" -ForegroundColor GREEN
Write-Host "================          ADDING TO DOMAIN        ================" -ForegroundColor GREEN
Write-Host "==================================================================" -ForegroundColor GREEN
Write-Output ""
Write-Output ""

# Prompt the user for the domain, username, password, and OU path
$domain = Read-Host "Enter the domain name (e.g., example.com)"
$username = Read-Host "Enter the domain admin username"
$password = Read-Host -AsSecureString "Enter the password for domain admin"
$OUPath = Read-Host "Enter the OU path (e.g., OU=Computers,OU=UK,DC=example,DC=com)"

$credential = New-Object System.Management.Automation.PSCredential("$domain\$username",$password)

# ADD THE COMPUTER TO THE DOMAIN AND SPECIFY THE ORGANIZATIONAL UNIT (OU) WHERE THE COMPUTER ACCOUNT SHOULD BE CREATED
Add-Computer -DomainName $domain -OUPath $OUPath -Credential $credential

# FORCE A GROUP POLICY UPDATE TO APPLY DOMAIN POLICIES
gpupdate /FORCE
timeout 3

# END OF SCRIPT
