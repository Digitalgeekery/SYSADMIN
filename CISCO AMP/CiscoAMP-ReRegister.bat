REM START OF SCRIPT

@echo off

<#
.SYNOPSIS
  Navigates to the most recent Cisco AMP version directory and runs an SFC registration command.
.DESCRIPTION
  This script locates the most recently created directory in the specified Cisco AMP folder that matches a version pattern (e.g., 1.2.3.4). It then navigates to that directory and runs a command to re-register Cisco AMP.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  Re-registers Cisco AMP using sfc.exe.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  21 February 2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run this batch file to automatically navigate to the latest Cisco AMP directory and execute the SFC registration command.
#>

REM SET LOCAL VARIABLES
setlocal

REM NAVIGATE TO THE CISCO AMP DIRECTORY
cd "C:\Program Files\Cisco\AMP"

REM FIND THE MOST RECENT DIRECTORY MATCHING THE VERSION PATTERN (E.G., 1.2.3.4)
for /f "delims=" %%f in ('dir /A:D /B /O:-D ^| findstr /r "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"') do (
    set tmpdata=%%f
    goto loopesc
)

REM ESCAPE TO THE LATEST VERSION DIRECTORY AND RUN SFC COMMAND
:loopesc
cd %tmpdata%
sfc.exe -reregister Cisco@Amp

REM END LOCAL VARIABLES
endlocal

REM END OF SCRIPT
