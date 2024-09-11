<#
.SYNOPSIS
  Schedules a daily shutdown task if it does not already exist.
.DESCRIPTION
  This script checks if a scheduled task to shut down the computer exists. If not, it creates a new task to shut down the computer daily at 06:00 AM, with a warning message to close open applications.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  A scheduled task to shut down the computer if it does not already exist.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  01 May 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script to ensure a daily shutdown task is scheduled if it is not already present.
#>

REM START OF SCRIPT

REM CHECK IF THE SCHEDULED TASK EXISTS
IF NOT EXIST C:\Windows\Tasks\at1.job (
    AT 06:00AM /EVERY:M,T,W,TH,F,S,SU C:\Windows\System32\shutdown.exe /s /t 30 /c "This computer will shutdown, please close your open applications. Your Administrator." /f
)

EXIT

REM END OF SCRIPT
