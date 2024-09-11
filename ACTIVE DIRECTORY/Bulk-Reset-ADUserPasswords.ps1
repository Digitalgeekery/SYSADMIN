<#
.SYNOPSIS
  Resets the password for a bulk number of users and sets the property to require a password change at the next logon.
.DESCRIPTION
  This script imports a list of user accounts from a file, resets their passwords to a default value, and optionally requires them to change their password at the next logon.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  A text file located at C:\hostnames.txt containing usernames, one per line.
.OUTPUTS
  Status messages indicating whether the password has been successfully reset for each user.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  5 March 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to reset user passwords and configure password change settings. Ensure that the text file with usernames exists at the specified location.
#>

# START OF SCRIPT

# IMPORT THE ACTIVE DIRECTORY MODULE
Import-Module ActiveDirectory

# SET THE DEFAULT PASSWORD
$password = ConvertTo-SecureString -AsPlainText "Password123" -Force 

# GET THE LIST OF ACCOUNTS FROM THE FILE
# LIST THE USER NAMES ONE PER LINE
$users = Get-Content -Path C:\UserNames.txt

# LOOP THROUGH EACH USER IN THE LIST
ForEach ($user in $users) {

    # SET THE DEFAULT PASSWORD FOR THE CURRENT ACCOUNT
    Get-ADUser -Identity $user | Set-ADAccountPassword -NewPassword $password -Reset
    
    # OPTIONAL: SET THE PROPERTY “CHANGE PASSWORD AT NEXT LOGON”
    # UNCOMMENT THE NEXT LINE TO REQUIRE A PASSWORD CHANGE AT NEXT LOGON
    # Get-ADUser -Identity $user | Set-ADUser -ChangePasswordAtLogon $true

    Write-Host "Password has been reset for the user: $user"
}

# END OF SCRIPT
