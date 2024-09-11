<#
.SYNOPSIS
  This script checks for administrative privileges and clears all Windows event logs.

.DESCRIPTION
  The script verifies if the current user has administrative privileges. If so, it proceeds to clear all Windows event logs using the `wevtutil` command. If administrative privileges are not detected, it provides instructions to run the script with elevated permissions.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Outputs messages indicating the success of clearing event logs and whether administrative privileges are sufficient.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Ensure the script is executed with administrative privileges to clear event logs.

.EXAMPLE
  Run the script to clear all Windows event logs. If the script is not run with administrative privileges, it will prompt the user to run it with elevated permissions.
#>

REM START OF SCRIPT

@echo off

REM CHECKING ADMIN PRIVILEGES
FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin

REM CLEARING EVENT LOGS
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")
echo.
echo All Event Logs have been cleared!
goto theEnd

:do_clear
REM CLEARING EVENT LOG %1
echo clearing %1
wevtutil.exe cl %1
goto :eof

:noAdmin
REM ADMINISTRATIVE PRIVILEGES REQUIRED
echo Current user permissions to execute this .BAT file are inadequate.
echo This .BAT file must be run with administrative privileges.
echo Exit now, right click on this .BAT file, and select "Run as administrator".  
pause >nul

:theEnd
REM EXITING SCRIPT
Exit

REM END OF SCRIPT
