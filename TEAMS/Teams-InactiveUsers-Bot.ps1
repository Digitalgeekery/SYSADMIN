<#
.SYNOPSIS
  Retrieves and reports inactive users who have not logged into their accounts within the past 90 days.
.DESCRIPTION
  This script identifies users within a specified Organizational Unit (OU) who have not logged into their accounts for 90 days or more. It generates a report and sends a notification to a Microsoft Teams webhook.
.PARAMETER None
.INPUTS
  NONE
.OUTPUTS
  Sends a notification to Microsoft Teams with a summary of inactive users.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module for PowerShell.
  TODO:           Verify that Teams webhook URL and image URL are correct.
.EXAMPLE
  .\InactiveUsersNotification.ps1
  This example runs the script to generate a notification about inactive users.
#>

# TEAMS WEBHOOK URL
$uri = "https://xxxxxxx.webhook.office.com/webhookb2/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx@xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/IncomingWebhook/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# IMAGE ON THE LEFT HAND SIDE
$ItemImage = 'https://img.icons8.com/color/1600/circled-user-male-skin-type-1-2.png'

# GET THE DATE TIME OBJECT FOR 90 DAYS AGO
$90Days = (Get-Date).AddDays(-90)

$InactiveUsersTable = New-Object 'System.Collections.Generic.List[System.Object]'
$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

# SPECIFY THE OU TO TARGET
$TargetOU = "OU=xxxx,OU=xxxx,OU=xxxx,DC=xxxx,DC=local"

# IF LASTLOGONDATE IS NOT EMPTY, AND LESS THAN OR EQUAL TO XX DAYS AND ENABLED WITHIN THE SPECIFIED OU
Get-ADUser -properties * -Filter { (LastLogonDate -like "*" -and LastLogonDate -le $90Days) -AND (Enabled -eq $True) } -SearchBase $TargetOU | ForEach-Object {
    Write-Host "Working on $($_.Name)" -ForegroundColor White
    
    $LastLogonDate = $_.LastLogonDate
    $Today = (Get-Date)
    
    $DaysSince = ((New-TimeSpan -Start $LastLogonDate -End $Today).Days).ToString() + " Days ago"
    
    $obj = [PSCustomObject]@{
        'Name' = $_.Name
        'LastLogon' = $DaysSince
        'LastLogonDate' = ($_.LastLogonDate).ToShortDateString()
        'EmailAddress' = $_.EmailAddress
        'LockedOut' = $_.LockedOut
        'UPN'  = $_.UserPrincipalName
        'Enabled' = $_.Enabled
        'PasswordNeverExpires' = $_.PasswordNeverExpires
        'SamAccountName' = $_.SamAccountName
    }
    
    $InactiveUsersTable.Add($obj)
}

Write-Host "Inactive users $($($InactiveUsersTable).count)"

$InactiveUsersTable | ForEach-Object {
    $Section = @{
        activityTitle = "$($_.Name)"
        activitySubtitle = "$($_.EmailAddress)"
        activityText  = "$($_.Name)'s last logon was $($_.LastLogon)"
        activityImage = $ItemImage
        facts          = @(
            @{
                name  = 'Last Logon Date:'
                value = $_.LastLogonDate
            },
            @{
                name  = 'Enabled:'
                value = $_.Enabled
            },
            @{
                name  = 'Locked Out:'
                value = $_.LockedOut
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
    title = "Inactive Users - Notification"
    text  = "There are $($ArrayTable.Count) users who have not logged in since $($90Days.ToShortDateString()) or earlier"
    sections = $ArrayTable
}

Write-Host "Sending inactive account POST" -ForegroundColor Green
Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType 'application/json'
