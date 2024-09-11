<#
.SYNOPSIS
  Processes the latest Excel file in a specified folder, categorises users based on their location and current location, and adds them to the appropriate distribution groups.
.DESCRIPTION
  This script searches for the most recent .xlsx file in a given folder, extracts user data from the file, categorises users based on their location and current location, and adds them to specific distribution groups in Exchange based on their DomainID.
.PARAMETER folderPath
    The path to the folder containing the Excel files.
.INPUTS
  Excel file with user data.
.OUTPUTS
  Outputs messages indicating the addition of users to distribution groups.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Excel application, Exchange PowerShell module
  TODO:           Ensure that the correct Exchange module is imported and available.

.EXAMPLE
  .\Process-Excel-UserData.ps1 -folderPath "D:\test"
#>

param (
    [string]$folderPath
)

# Find the latest .xlsx file in the folder
$latestFile = Get-ChildItem -Path $folderPath -Filter "*.xlsx" | 
              Sort-Object LastWriteTime -Descending | 
              Select-Object -First 1

if (-not $latestFile) {
    Write-Output "No .xlsx files found in $folderPath"
    exit
}

# Import Excel file and sheet
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($latestFile.FullName)
$sheet = $workbook.Sheets.Item(1) # Assuming data is on the first sheet

# Convert sheet data to an array for easier handling (assuming headers on the first row)
$rows = @()
$usedRange = $sheet.UsedRange
for ($row = 2; $row -le $usedRange.Rows.Count; $row++) {
    $rows += [pscustomobject]@{
        'EMPLID' = $usedRange.Cells.Item($row, 1).Text           # Column A
        'EmployeeName' = $usedRange.Cells.Item($row, 3).Text      # Column C
        'EmailID' = $usedRange.Cells.Item($row, 4).Text           # Column D
        'Location' = $usedRange.Cells.Item($row, 12).Text         # Column L
        'CurrentLocation' = $usedRange.Cells.Item($row, 14).Text  # Column N
        'DomainID' = $usedRange.Cells.Item($row, 40).Text         # Column AN
    }
}

# Close Excel
$workbook.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

# Define the lists for each category
$workingFromOffice = @()
$hybrid = @()
$workingFromHome = @()

# Filter users based on Location (Column L) and Current Location (Column N)
foreach ($user in $rows) {
    if ($user.Location -eq "city") {
        switch ($user.CurrentLocation) {
            "Working from Office" { $workingFromOffice += $user }
            "Hybrid" { $hybrid += $user }
            "Working from Home" { $workingFromHome += $user }
        }
    }
}

# Function to add users to a distribution group based on DomainID
function Add-ToDistributionGroup {
    param (
        [string]$groupName,
        [array]$users
    )

    foreach ($user in $users) {
        $domainID = $user.DomainID
        # Check if the user is already a member of the group
        $currentGroup = Get-DistributionGroupMember -Identity $groupName | Where-Object {$_.Name -eq $domainID}
        
        # Add user if not already in the correct group
        if (-not $currentGroup) {
            Add-DistributionGroupMember -Identity $groupName -Member $domainID
            Write-Output "$domainID added to $groupName"
        }
    }
}

# Add users from each list to their respective distribution groups using DomainID (Column AN)
Add-ToDistributionGroup -groupName "WFO" -users $workingFromOffice
Add-ToDistributionGroup -groupName "Hybrid" -users $hybrid
Add-ToDistributionGroup -groupName "WFH" -users $workingFromHome

Write-Output "Users added to the respective distribution groups."
