<#
.SYNOPSIS
  Searches for Active Directory users whose SamAccountName matches a specified pattern.
.DESCRIPTION
  This script prompts the user to enter a part of a username and then searches Active Directory for users whose SamAccountName contains the specified text. The search results are displayed on the screen.
.PARAMETER None
    No parameters are required for this script. The user will be prompted to input a search string.
.INPUTS
  A string input from the user for searching SamAccountNames.
.OUTPUTS
  Displays the search results in the PowerShell console.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10 September 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in a PowerShell environment. Enter a partial username when prompted, and the script will display all matching users whose SamAccountName contains the specified text.
#>

# START OF SCRIPT

# PROMPT THE USER TO ENTER PART OF THE USERNAME
$UserName = Read-Host "Enter part of the UserName you seek"

# SEARCH FOR ACTIVE DIRECTORY USERS WHOSE SAMACCOUNTNAME MATCHES THE SPECIFIED PATTERN
Get-ADUser -Filter "SamAccountName -like '*$UserName*'"

# END OF SCRIPT
