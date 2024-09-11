<#
.SYNOPSIS
  Continuously checks the system time and initiates a shutdown at 22:00.
.DESCRIPTION
  This script continuously monitors the system time and triggers a system shutdown at exactly 22:00 (10 PM), providing a warning message to close open applications.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  A system shutdown command executed at 22:00.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  02 May 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script to ensure that the computer shuts down automatically at 22:00.
#>

REM START OF SCRIPT

:W
REM CHECK IF THE CURRENT TIME IS 22:00:00.00
IF %TIME%==22:00:00.00 GOTO :X
GOTO :W

:X
REM EXECUTE SHUTDOWN COMMAND WITH A 60-SECOND TIMER AND A WARNING MESSAGE
SHUTDOWN.EXE /S /F /T 60 /C "This computer will shutdown, please close your open applications. Your Administrator."

REM END OF SCRIPT
