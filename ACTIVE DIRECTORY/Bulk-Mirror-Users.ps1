<#
.SYNOPSIS
  Updates user group memberships and moves users to a specified organisational unit (OU).
.DESCRIPTION
  This script reads a list of target users from a text file, removes them from all their current groups, adds them to the same groups as a specified source user (excluding "Domain Users"), and moves them to the same organisational unit (OU) as the source user.
.PARAMETER None
.INPUTS
  - A text file located at C:\usernames.txt containing the list of target usernames.
.OUTPUTS
  Outputs messages indicating the success of updates for each user.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module for PowerShell.

.EXAMPLE
  .\Bulk-Mirror -Users.ps1
#>

# Read target users from text file
$userList = Get-Content -Path "C:\usernames.txt"

# Set the source user
$sourceUser = 'MASTER_USERNAME_HERE'

# Loop through each user
foreach ($targetUser in $userList) {
    Write-Host "Updating user: $targetUser"
    
    # Retrieve target user object and its properties
    $targetUserObject = Get-ADUser $targetUser -Properties DistinguishedName, MemberOf

    # Get source groups except Domain Users
    $sourceGroups = Get-ADPrincipalGroupMembership $sourceUser | Where-Object {$_.Name -ne 'Domain Users'}

    # Get source OU
    $sourceOU = (Get-ADUser $sourceUser -Properties DistinguishedName).DistinguishedName.Split(',', 2)[1]

    # Remove all target groups
    foreach ($group in $($targetUserObject.MemberOf)) {
        Remove-ADGroupMember -Identity $group -Members $targetUser -Confirm:$false
    }

    # Add user to source Groups and move to source OU
    Add-ADPrincipalGroupMembership -Identity $targetUser -MemberOf $sourceGroups
    Move-ADObject -Identity $($targetUserObject.DistinguishedName) -TargetPath $sourceOU
    
    Write-Host "User $targetUser updated."
}

Write-Host "Updates for all users completed."
