<#
.SYNOPSIS
  Retrieves all user information from a specified Active Directory Organizational Unit (OU) and exports the details to a CSV file.
.DESCRIPTION
  This script queries Active Directory for all users in the specified OU, retrieves details such as display name, distinguished name, and enabled status, and exports the results to a CSV file.
.PARAMETER None
    No parameters are required for this script. The OU path and export file location are specified within the script.
.INPUTS
  None
.OUTPUTS
  A CSV file containing user information is saved to the path specified in the $exportPath. Example: C:\export-ou.csv
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10 September 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to query Active Directory. The script will export user details to a CSV file at the specified path.
#>

# START OF SCRIPT

# QUERY ACTIVE DIRECTORY FOR USERS IN THE SPECIFIED OU WITH DEMO VALUES
Get-ADUser -Filter * -Properties * -SearchBase "OU=Demo,DC=demoDomain,DC=local" | 
select displayname, DistinguishedName, Enabled |

# EXPORT THE RESULTS TO A CSV FILE AT THE SPECIFIED PATH WITH A DEMO VALUE
Export-Csv -Path C:\Demo\export-ou.csv -NoTypeInformation

# END OF SCRIPT
