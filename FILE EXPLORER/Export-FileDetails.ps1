<#
.SYNOPSIS
  Retrieves details about files in a specified directory and exports the information to a CSV file.
.DESCRIPTION
  This script scans the specified directory for files and collects details such as file name and last modified date. The collected data is then exported to a CSV file for reporting purposes.
.PARAMETER None
    No parameters are required for this script. The directory paths are specified within the script.
.INPUTS
  None
.OUTPUTS
  A CSV file containing file details is saved to the path specified in $exportPath. Example: C:\Users\demoUser\Desktop\FileDetails.csv
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  10 September 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script in a PowerShell environment. The script will collect file details from the specified input directory and export the results to the CSV file at the specified export path.
#>

# START OF SCRIPT

# SPECIFY THE INPUT DIRECTORY WITH A DEMO VALUE
$inputPath = "F:\DemoDirectory"

# SPECIFY THE EXPORT PATH FOR THE CSV FILE WITH A DEMO VALUE
$exportPath = "C:\Users\demoUser\Desktop\FileDetails.csv"

# GET LIST OF FILES IN THE SPECIFIED INPUT DIRECTORY
$files = Get-ChildItem -Path $inputPath

# INITIALIZE AN EMPTY ARRAY TO STORE FILE DETAILS
$fileDetails = @()

# ITERATE THROUGH EACH FILE AND EXTRACT FILE NAME AND LAST MODIFIED DATE
foreach ($file in $files) {
    $fileName = $file.Name
    $lastModified = $file.LastWriteTime
    $fileDetails += [PSCustomObject]@{
        FileName = $fileName
        LastModified = $lastModified
    }
}

# EXPORT THE FILE DETAILS TO A CSV FILE AT THE SPECIFIED EXPORT PATH
$fileDetails | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "File details exported to $exportPath"

# END OF SCRIPT
