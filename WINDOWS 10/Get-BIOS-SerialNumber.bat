<#
.SYNOPSIS
  Retrieves the system's BIOS serial number.

.DESCRIPTION
  This script uses the WMIC command to retrieve the BIOS serial number of the system. It then pauses to allow the user to view the output before closing.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Outputs the BIOS serial number to the console.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None

.EXAMPLE
  Run the script to retrieve and display the BIOS serial number.
#>

REM START OF SCRIPT

WMIC BIOS GET SERIALNUMBER
pause

REM END OF SCRIPT
