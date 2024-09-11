<#
.SYNOPSIS
  Adds a new registry entry to run a specified application at startup.

.DESCRIPTION
  This script creates a new registry entry under the "Run" key in the Windows Registry, which will execute the specified application (in this case, the Calculator) each time the system starts.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Updates the Windows Registry to include the specified application in the startup list.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None

.EXAMPLE
  Run the script to add an entry for "calc.exe" to the startup applications.
#>

REM START OF SCRIPT

New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" `
    -Name "Application" `
    -Value "c:\windows\system32\calc.exe"

REM END OF SCRIPT
