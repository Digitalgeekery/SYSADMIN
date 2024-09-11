REM START OF SCRIPT
<#
.SYNOPSIS
  Collects system information and exports it to a network location.
.DESCRIPTION
  This script maps a network drive, collects system information including hostname, MAC address, and serial number, and exports it to a specified network location. It then unmaps the network drive.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  A text file containing system information is created on the network drive.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None

.EXAMPLE
  Run the script to export system information to \\192.168.0.1\PC_CHECK_IN_OUTPUT.
#>

@echo off
net use b: \\192.168.0.1\PC_CHECK_IN_OUTPUT
set hostname=hostname
for /f %%a in ('hostname') do set "hostname=%%a"
hostname > b:\%hostname%.txt
getmac >> b:\%hostname%.txt
wmic csproduct get /value >> b:\%hostname%.txt

whoami >> b:\%hostname%.txt

net use b: /delete
pause
REM END OF SCRIPT
