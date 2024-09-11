<#
.SYNOPSIS
  This script performs maintenance tasks on the SCCM (System Centre Configuration Manager) client by stopping the service, removing configuration files, and cleaning up inventory actions.

.DESCRIPTION
  The script stops the SCCM client service, deletes specific configuration files, removes certificates related to SCCM from the registry, and clears a particular inventory action status from WMI.

.PARAMETER None
    This script does not require any parameters.

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
  TODO:           None

.EXAMPLE
  Run the script to perform the necessary maintenance on the SCCM client. The script will display messages indicating the progress of each step and pause at the end for review.

#>

Write-Host "FIXING SCCM GOLDEN IMAGE...."

# STOP SCCM CLIENT SERVICE
net stop ccmexec

# REMOVE SCCM CONFIGURATION FILE
Remove-Item 'c:\windows\smscfg.ini'

# REMOVE SCCM CERTIFICATES FROM REGISTRY
Remove-Item -Path HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\* -Force

# CLEAN UP SPECIFIC INVENTORY ACTION STATUS
Get-WmiObject -Namespace root\ccm\invagt -Class Inventoryactionstatus | Where-Object {$_.inventoryactionid -eq "{00000000-0000-0000-0000-000000000001}"} | Remove-WmiObject

# PAUSE FOR USER REVIEW
Pause
