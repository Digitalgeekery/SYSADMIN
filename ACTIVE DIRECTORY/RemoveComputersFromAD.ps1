<#
.SYNOPSIS
  Removes a list of computers from Active Directory based on hostnames specified in a text file.
.DESCRIPTION
  This script imports the Active Directory module and reads hostnames from a text file. It then attempts to remove each computer from Active Directory using the provided hostname. The removal is done without confirmation prompts.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  A text file located at C:\hostnames.txt containing a list of hostnames (one per line).
.OUTPUTS
  No direct outputs. A message is displayed for each computer removed from Active Directory.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  17 February 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to remove computers from Active Directory. Ensure that C:\hostnames.txt exists and contains the list of hostnames to be removed.
#>

# START OF SCRIPT

# IMPORT THE ACTIVE DIRECTORY MODULE
Import-Module ActiveDirectory

# DEFINE THE PATH TO THE HOSTNAMES FILE
$hostnames = Get-Content -Path C:\hostnames.txt 

# LOOP THROUGH EACH HOSTNAME AND REMOVE THE COMPUTER FROM ACTIVE DIRECTORY
ForEach ($hostname in $hostnames) 
{
    Get-ADComputer $hostname | Remove-ADObject -Confirm:$false
    Write-Host "This PC has been removed from AD: $hostname"
}

# END OF SCRIPT
