<#
.SYNOPSIS
  Retrieves information about all users in a specified Active Directory Organizational Unit (OU) and exports it to a CSV file.
.DESCRIPTION
  This script queries Active Directory for users in the specified OU and collects details such as display name, SamAccountName, user principal name, enabled status, and last logon date. The collected data is then exported to a CSV file for reporting purposes.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  A CSV file containing user information is saved to the path specified in $outputCsvPathUsers. Example: C:\UserInformationReport.csv
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10 September 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to query Active Directory and write to the CSV file. The script will output the file path where the results are saved.
#>

# START OF SCRIPT

# DEFINE THE TARGET ORGANIZATIONAL UNIT (OU) FOR USERS WITH DEMO VALUE
$ouUsers = "OU=Demo,DC=demoDomain,DC=local"  # UPDATE THIS WITH THE DESIRED OU FOR USERS

# GET ALL USERS IN THE SPECIFIED OU
$users = Get-ADUser -Filter * -SearchBase $ouUsers -Properties DistinguishedName, DisplayName, SamAccountName, UserPrincipalName, Enabled, LastLogonDate

# DEFINE THE OUTPUT CSV FILE PATH FOR USERS
$outputCsvPathUsers = "C:\UserInformationReport.csv"

# ITERATE THROUGH EACH USER AND STORE THE RESULTS IN AN ARRAY
$resultsUsers = foreach ($user in $users) {
    [PSCustomObject]@{
        DisplayName = $user.DisplayName
        SamAccountName = $user.SamAccountName
        UserPrincipalName = $user.UserPrincipalName
        Enabled = $user.Enabled
        LastLogonDate = if ($user.LastLogonDate) { $user.LastLogonDate } else { "Not available" }
        DistinguishedName = $user.DistinguishedName
    }
}

# EXPORT THE USER RESULTS TO A CSV FILE
$resultsUsers | Export-Csv -Path $outputCsvPathUsers -NoTypeInformation

Write-Output "User results exported to $outputCsvPathUsers"

# END OF SCRIPT
