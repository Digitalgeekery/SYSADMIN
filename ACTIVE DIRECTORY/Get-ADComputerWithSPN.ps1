<#
.SYNOPSIS
  Retrieves Active Directory computer objects with specific Service Principal Names (SPNs).

.DESCRIPTION
  This script queries Active Directory for computer objects and filters them based on the presence of a specific Service Principal Name (SPN). It returns the computer objects where the SPN contains the string 'UKHW-709'.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Displays Active Directory computer objects with Service Principal Names matching 'UKHW-709'.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  25/09/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module for Windows PowerShell
  TODO:           None

.EXAMPLE
  Run the script to retrieve computer objects in Active Directory where the Service Principal Name contains 'UKHW-709'.

#>

#START OF SCRIPT

Get-ADComputer -Filter * -Properties ServicePrincipalNames | Where-Object { $_.ServicePrincipalNames -match 'UKHW-709' }

#END OF SCRIPT
