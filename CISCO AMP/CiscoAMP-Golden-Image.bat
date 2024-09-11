REM START OF SCRIPT

@echo off

<#
.SYNOPSIS
  Executes a series of commands to re-register Cisco AMP, modify configuration files, and remove specific registry keys.
.DESCRIPTION
  This script navigates to a specific Cisco AMP version directory, runs the SFC registration, waits for a period, and then deletes and recreates a local configuration file. It also removes specified registry entries related to Immunet Protect.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  Re-registers Cisco AMP, modifies configuration files, and removes certain registry keys.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  05 April 2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run this batch file to reset Cisco AMP, modify the configuration, and remove registry keys for Immunet Protect.
#>

REM NAVIGATE TO THE SPECIFIED CISCO AMP VERSION DIRECTORY
cd\Program Files\Cisco\AMP\7.3.9

REM RUN THE SFC COMMAND TO REGISTER CISCO AMP
sfc.exe -k Cisco@Amp

REM WAIT FOR 45 SECONDS BEFORE PROCEEDING
timeout 45

REM DELETE THE LOCAL CONFIGURATION FILE
del "C:\Program Files\Cisco\AMP\local.xml"

REM RECREATE A BASIC CONFIGURATION FILE FOR CISCO AMP
echo ^<config^>^</config^> > "%PROGRAMFILES%\Cisco\AMP\local.xml"

REM DELETE SPECIFIC REGISTRY ENTRIES RELATED TO IMMUNET PROTECT
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Immunet Protect" /v "client_cert" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Immunet Protect" /v "client_keypair" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Immunet Protect" /v "est_cert" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Immunet Protect" /v "guid" /f

REM END OF SCRIPT
