<#
.SYNOPSIS
  Retrieves users whose passwords are expiring soon or have already expired and sends notifications to a Teams channel.
.DESCRIPTION
  This script checks for users whose passwords are expiring in the next X days or are already expired. It then sends notifications to a specified Teams channel using a webhook URL.
.PARAMETER LessThan
    The number of days before the password expires to trigger a notification.
.INPUTS
  Reads user data from Active Directory.
.OUTPUTS
  Sends a notification to a Teams channel.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module for Windows PowerShell
  TODO:           Add error handling for Teams webhook requests
#>

$SendMessage = $null
# Get all users whose password expires in X days and less, this sets the days
$LessThan = 7

# Teams web hook URL
$uri = "https://example.webhook.office.com/webhookb2/your-webhook-url"  # Replace with your actual Teams webhook URL

$ItemImage = 'https://img.icons8.com/color/1600/circled-user-male-skin-type-1-2.png'

$PWExpiringTable = New-Object 'System.Collections.Generic.List[System.Object]'
$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'
$ArrayTableExpired = New-Object 'System.Collections.Generic.List[System.Object]'

$ExpiringUsers = 0
$ExpiredUsers = 0

$maxPasswordAge = ((Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge).Days

# Specify the target Organizational Unit (OU) DN
$targetOU = "OU=DemoOU,OU=DemoRegion,OU=DemoCountry,OU=DemoCompany,DC=demo,DC=local"  # Replace with your actual demo OU DN

# Get all users within the specified OU and store in a variable named $Users
Get-ADUser -Filter { (PasswordNeverExpires -eq $false) -and (Enabled -eq $true) } -Properties * -SearchBase $targetOU | ForEach-Object {
    Write-Host "Working on $($_.Name)" -ForegroundColor White

    # Get Password last set date
    $passwordSetDate = ($_.PasswordLastSet)
    
    if ($null -eq $passwordSetDate) {
        #0x1 = Never Logged On
        $daystoexpire = "0x1"
    } else {
        # Check for Fine Grained Passwords
        $PasswordPol = (Get-ADUserResultantPasswordPolicy -Identity $_.objectGUID -ErrorAction SilentlyContinue)
        
        if ($Null -ne ($PasswordPol)) {
            $maxPasswordAge = ($PasswordPol).MaxPasswordAge
        }
        
        $expireson = $passwordSetDate.AddDays($maxPasswordAge)
        $today = (Get-Date)
        
        # Gets the count on how many days until the password expires and stores it in the $daystoexpire var
        $daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days
        If ($daystoexpire -lt ($LessThan + 1)) {
            Write-Host "$($_.Name) will be added to table" -ForegroundColor Red
            If ($daystoexpire -lt 0) {
                #0x2 = Password has been expired
                $daystoexpire = "Password is Expired"
            }
            $obj = [PSCustomObject]@{
                'Name' = $_.name
                'DaysUntil' = $daystoexpire
                'EmailAddress' = $_.emailaddress
                'LastSet' = $_.PasswordLastSet.ToShortDateString()
                'LockedOut' = $_.LockedOut
                'UPN' = $_.UserPrincipalName
                'Enabled' = $_.Enabled
                'PasswordNeverExpires' = $_.PasswordNeverExpires
            }
            
            $PWExpiringTable.Add($obj)
        } else {
            Write-Host "$($_.Name)'s account is compliant" -ForegroundColor Green
        }
    }
}

# Sort the table so the Teams message shows expiring soonest to latest
$PWExpiringTable = $PWExpiringTable | Sort-Object DaysUntil

$PWExpiringTable | ForEach-Object {
    If ($_.DaysUntil -eq "Password is Expired") {
        Write-Host "$($_.name) is expired" -ForegroundColor DarkRed
        $ExpiredUsers++
        $SectionExpired = @{
            activityTitle = "$($_.Name)"
            activitySubtitle = "$($_.EmailAddress)"
            activityText = "$($_.Name)'s password has already expired!"
            activityImage = $ItemImage
        }
        $ArrayTableExpired.Add($SectionExpired)
    } Else {
        Write-Host "$($_.name) is expiring" -ForegroundColor DarkYellow
        $ExpiringUsers++
        $Section = @{
            activityTitle = "$($_.Name)"
            activitySubtitle = "$($_.EmailAddress)"
            activityText = "$($_.Name) needs to change their password in $($_.DaysUntil) days"
            activityImage = $ItemImage
        }
        $ArrayTable.Add($Section)
    }
}

Write-Host "Expired Accounts: $($ExpiredUsers)" -ForegroundColor Yellow
Write-Host "Expiring Accounts: $($ExpiringUsers)" -ForegroundColor Yellow

$body = ConvertTo-Json -Depth 8 @{
    title = 'Users With Password Expiring - Notification'
    text = "There are $($ArrayTable.Count) users that have passwords expiring in $($LessThan) days or less"
    sections = $ArrayTable
}

Write-Host "Sending expiring users notification" -ForegroundColor Green
Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType 'application/json'

$body2 = ConvertTo-Json -Depth 8 @{
    title = 'Users With Password Expired - Notification'
    text = "There are $($ArrayTableExpired.Count) users that have passwords that have expired already"
    sections = $ArrayTableExpired
}

Write-Host "Sending expired users notification" -ForegroundColor Green
Invoke-RestMethod -Uri $uri -Method Post -Body $body2 -ContentType 'application/json'
