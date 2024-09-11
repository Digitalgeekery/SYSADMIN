<#
.SYNOPSIS
  Creates a PowerShell script file with a menu for selecting between two options: Work From Office (WFO) and Work From Home (WFH).

.DESCRIPTION
  This script checks if a specified folder exists and creates it if it doesn't. It then writes a new PowerShell script file with functions for "Work From Office" and "Work From Home", and provides a menu for the user to select which function to execute.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Creates a new PowerShell script file at the specified path with predefined content.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  15/03/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Ensure proper validation and error handling for file operations.

.EXAMPLE
  Run the script to create a new PowerShell script file with a menu for selecting WFO or WFH options.

#>

#START OF SCRIPT

# Define the folder and file path
$folderPath = "C:\BUILDOPTIONSv3\SCRIPTS"
$filePath = "$folderPath\BUILD_MENU_24.ps1"

# Create the folder if it doesn't exist
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory -Force
}

# Define the content of the script to copy to the new file
$scriptContent = @'
# Function for Work From Office (WFO)
function WorkFromOffice {
    # START SCRIPT 1
    Write-Host "Executing Work From Office script..."
    # END SCRIPT 1
}

# Function for Work From Home (WFH)
function WorkFromHome {
    # START SCRIPT 2
    Write-Host "Executing Work From Home script..."
    # END SCRIPT 2
}

# Menu to select the option
Clear-Host
Write-Host "---------------------------------------------" -ForegroundColor Cyan
Write-Host "             SELECT AN OPTION                " -ForegroundColor Cyan
Write-Host "---------------------------------------------" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Work From Office (WFO)"
Write-Host "2. Work From Home (WFH)"
Write-Host ""
$selection = Read-Host "Enter the number of your choice"

# Decision-making based on the user's selection
switch ($selection) {
    1 {
        WorkFromOffice
    }
    2 {
        WorkFromHome
    }
    default {
        Write-Host "Invalid selection. Please run the script again and choose a valid option." -ForegroundColor Red
    }
}
'@

# Write the content to the new script file
$scriptContent | Set-Content -Path $filePath

# Optional: Output a message confirming the operation
Write-Host "Script has been created at $filePath"

#END OF SCRIPT
