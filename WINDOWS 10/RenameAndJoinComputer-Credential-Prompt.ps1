<#
.SYNOPSIS
  Renames the computer and joins it to a domain.
.DESCRIPTION
  This script prompts for a new computer name, obtains domain credentials, joins the computer to the specified domain, and then renames the computer.
.PARAMETER NewName
  The new name for the computer. Enter this value when prompted.
.PARAMETER DomainName
  The domain name to which the computer will be joined. This is set to a demo domain in the script.
.PARAMETER Credential
  The credentials used to join the domain. This is prompted from the user.
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
  .\RenameAndJoinComputer.ps1
  This example runs the script, prompts for a new name and domain credentials, joins the computer to the domain, and renames it.
#>

# PROMPT FOR THE NEW COMPUTER NAME
$getName = Read-Host -Prompt "Enter the new name for this computer"

# PROMPT FOR DOMAIN CREDENTIALS
$whoamI = Get-Credential

# JOIN COMPUTER TO DOMAIN AND RESTART
Add-Computer -NewName $getName -DomainName "DEMO_DOMAIN.LOCAL" -Credential $whoamI -Restart

# RENAME THE COMPUTER
Rename-Computer -NewName $getName
