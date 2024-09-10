<#
.SYNOPSIS
  Retrieves information about all computers in a specified Active Directory Organizational Unit (OU) and exports it to a CSV file.
.DESCRIPTION
  This script queries Active Directory for computers in the specified OU and collects details such as name, last logon date, DNS host name, operating system, enabled status, and IPv4 address. The collected data is then exported to a CSV file for reporting purposes.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  A CSV file containing computer information is saved to the path specified in $outputCsvPath. Example: C:\ComputerInformationReport.csv
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10 September 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to query Active Directory and write to the CSV file. The script will output the file path where the results are saved.
#>

# START OF SCRIPT

# DEFINE THE TARGET ORGANIZATIONAL UNIT (OU) WITH DEMO VALUE
$ou = "OU=Demo,OU=Computers,DC=demoDomain,DC=local"  # UPDATE THIS WITH THE DESIRED OU

# GET ALL COMPUTERS IN THE SPECIFIED OU
$computers = Get-ADComputer -Filter * -SearchBase $ou -Properties Name, DistinguishedName, DNSHostName, OperatingSystem, LastLogonDate, Enabled, IPv4Address

# DEFINE THE OUTPUT CSV FILE PATH
$outputCsvPath = "C:\ComputerInformationReport.csv"

# ITERATE THROUGH EACH COMPUTER AND STORE THE RESULTS IN AN ARRAY
$results = foreach ($computer in $computers) {
    [PSCustomObject]@{
        Name = $computer.Name
        LastLogonDate = if ($computer.LastLogonDate) { $computer.LastLogonDate } else { "Not available" }
        DNSHostName = $computer.DNSHostName
        OperatingSystem = $computer.OperatingSystem
        Enabled = $computer.Enabled
        IPv4Address = $computer.IPv4Address
        DistinguishedName = $computer.DistinguishedName
    }
}

# EXPORT THE RESULTS TO A CSV FILE
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Output "Results exported to $outputCsvPath"

# END OF SCRIPT
