<#
.SYNOPSIS
  Clears the Microsoft Teams cache and restarts the Teams application.

.DESCRIPTION
  This script prompts the user to decide whether to clear the Teams cache. If the user agrees, it stops the Teams process if it is running, clears all cache files related to Teams, and then restarts the Teams application.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Outputs messages indicating the success or failure of stopping the Teams process, clearing the cache, and restarting the application.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  25/09/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Consider adding additional error handling and logging.

.EXAMPLE
  Run the script and follow the prompt to clear the Teams cache and restart the application as needed.

#>

#START OF SCRIPT

$clearCache = Read-Host "Do you want to delete the Teams Cache (Y/N)?"
$clearCache = $clearCache.ToUpper()

if ($clearCache -eq "Y") {
    Write-Host "Closing Teams" -ForegroundColor Cyan
    
    try {
        if (Get-Process -ProcessName Teams -ErrorAction SilentlyContinue) { 
            Get-Process -ProcessName Teams | Stop-Process -Force
            Start-Sleep -Seconds 3
            Write-Host "Teams Successfully Closed" -ForegroundColor Green
        } else {
            Write-Host "Teams is Already Closed" -ForegroundColor Green
        }
    } catch {
        Write-Error $_
    }

    Write-Host "Clearing Teams Cache" -ForegroundColor Cyan

    try {
        Get-ChildItem -Path "$env:APPDATA\Microsoft\teams" | Remove-Item -Recurse -Confirm:$false
        Write-Host "Teams Cache Removed" -ForegroundColor Green
    } catch {
        Write-Error $_
    }

    Write-Host "Cleanup Complete... Launching Teams" -ForegroundColor Green
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe"
}

#END OF SCRIPT
