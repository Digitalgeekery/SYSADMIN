<#
.SYNOPSIS
  Manages local user group memberships by adding the current user and removing specified users.
.DESCRIPTION
  This script adds the current user to the local "users" group and removes other specified users from the same group. It is intended as a last resort for managing user access when Active Directory restrictions are insufficient.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  Outputs messages indicating the success of adding and removing users from the local group.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Administrative privileges to modify local group memberships.

.EXAMPLE
  .\Manage-LocalUserGroup.ps1
#>

# Add the current user to the local "users" group
[string]$user = (Get-CimInstance -ClassName Win32_ComputerSystem).Username
Echo "Adding current user: $user"
Add-LocalGroupMember -Group "users" -Member "cadomain\$user"

# Remove other users from the local "users" group
Echo "Removing other users"
Remove-LocalGroupMember -Group "users" -Member "NT AUTHORITY\Authenticated Users"
Remove-LocalGroupMember -Group "users" -Member "NT AUTHORITY\Interactive"
Remove-LocalGroupMember -Group "users" -Member "cadomain\Users"

Pause
