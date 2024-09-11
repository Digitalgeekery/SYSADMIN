<#
.SYNOPSIS
  Renames a computer and restarts it.
.DESCRIPTION
  This script renames the computer to a specified new name and then restarts it to apply the changes.
.PARAMETER NewName
  The new name for the computer. Replace this with the desired name for the computer.
.INPUTS
  NONE
.OUTPUTS
  NONE
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       NONE
  TODO:           NONE
.EXAMPLE
  .\RenameComputerAndRestart.ps1
  This example runs the script to rename the computer and restart it.
#>

# RENAME THE COMPUTER TO THE NEW NAME AND RESTART
Rename-Computer -NewName "NEW-PC-NAME-HERE" -Restart
