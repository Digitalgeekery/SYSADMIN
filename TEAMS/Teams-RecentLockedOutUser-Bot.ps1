<#
.SYNOPSIS
  Retrieves and reports the most recently locked out user within a specified Organizational Unit (OU).
.DESCRIPTION
  This script identifies the most recently locked out user within a specified OU and sends a notification to a Microsoft Teams webhook.
.PARAMETER None
.INPUTS
  NONE
.OUTPUTS
  Sends a notification to Microsoft Teams with details of the most recently locked out user.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module for PowerShell.
  TODO:           Verify that Teams webhook URL and image URL are correct.
.EXAMPLE
  .\RecentLockedOutUserNotification.ps1
  This example runs the script to generate a notification about the most recently locked out user.
#>

# DEFINE THE DISTINGUISHED NAME OF THE OU YOU WANT TO TARGET
$TargetOU = "OU=xxxx,OU=xxxx,OU=xxxx,DC=xxxx,DC=local"

# TEAMS WEBHOOK URL
$uri = "https://xxxxxxx.webhook.office.com/webhookb2/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx@xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/IncomingWebhook/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# IMAGE ON THE LEFT HAND SIDE
$ItemImage = 'https://img.icons8.com/color/1600/circled-user-male-skin-type-1-2.png'

$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

# SEARCH FOR LOCKED OUT USERS IN THE SPECIFIED OU
$RecentLockedOutUser = Search-ADAccount -SearchBase $TargetOU -LockedOut | Get-ADUser -Properties badpwdcount, lockoutTime, lockedout, emailaddress | Select-Object badpwdcount, lockedout, Name, EmailAddress, SamAccountName, @{ Name = "LockoutTime"; Expression = { ([datetime]::FromFileTime($_.lockoutTime).ToLocalTime()) } } | Sort-Object LockoutTime -Descending | Select-Object -first 1

$RecentLockedOutUser | ForEach-Object {
    
    $Section = @{
        activityTitle = "$($_.Name)"
        activitySubtitle = "$($_.EmailAddress)"
        activityText  = "$($_.Name)'s account was locked out at $(($_.LockoutTime).ToString("hh:mm:ss tt")) and may require additional assistance"
        activityImage = $ItemImage
        facts          = @(
            @{
                name  = 'Lock-Out Timestamp:'
                value = $_.LockoutTime.ToString()
            },
            @{
                name  = 'Locked Out:'
                value = $_.lockedout
            },
            @{
                name  = 'Bad Password Count:'
                value = $_.badpwdcount
            },
            @{
                name  = 'SamAccountName:'
                value = $_.SamAccountName
            }
        )
    }
    $ArrayTable.add($section)
}

$body = ConvertTo-Json -Depth 8 @{
    title = "Locked Out User - Notification"
    text  = "$($RecentLockedOutUser.Name)'s account got locked out at $(($RecentLockedOutUser.LockoutTime).ToString("hh:mm:ss tt"))"
    sections = $ArrayTable
    
}
Write-Host "Sending locked out account POST" -ForegroundColor Green
Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType 'application/json'
