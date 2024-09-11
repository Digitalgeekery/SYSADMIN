<#
.SYNOPSIS
  Moves users from their current Organizational Unit (OU) to a specified target OU based on data imported from a CSV file.
.DESCRIPTION
  This script imports user data from a CSV file and moves each user to the specified target OU in Active Directory. It handles user accounts by their SamAccountName and provides status updates during the process.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  A CSV file located at C:\Users\martindohert\Downloads\vpn.csv containing user data with at least a SamAccountName field.
.OUTPUTS
  Status messages indicating whether each user was successfully moved or if an error occurred.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  17 February 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to move users between OUs. Ensure that the CSV file exists and contains the user data to be moved.
#>

# START OF SCRIPT

# IMPORT THE ACTIVE DIRECTORY MODULE
Import-Module ActiveDirectory

# IMPORT THE DATA FROM THE CSV FILE AND ASSIGN IT TO A VARIABLE
$Import_csv = Import-Csv -Path "C:\LIST.csv"

# SPECIFY TARGET OU WHERE THE USERS WILL BE MOVED TO
$TargetOU = "OU=DemoOU,DC=demoDomain,DC=com"  # DEMO DATA

# LOOP THROUGH EACH USER IN THE IMPORTED CSV DATA
$Import_csv | ForEach-Object {

    # RETRIEVE DN OF USER
    $UserDN = (Get-ADUser -Identity $_.SamAccountName).DistinguishedName

    Write-Host "Moving Accounts....."

    # MOVE USER TO TARGET OU
    Move-ADObject -Identity $UserDN -TargetPath $TargetOU -ErrorAction Stop 

} 

Write-Host "Completed move"

# PAUSE TO VIEW OUTPUT
Pause

# END OF SCRIPT
