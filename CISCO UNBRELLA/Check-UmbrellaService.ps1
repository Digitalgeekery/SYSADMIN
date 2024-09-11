<#
.SYNOPSIS
  Checks if the Umbrella Roaming Client service is running and attempts to restart it if necessary.
.DESCRIPTION
  This script verifies the status of the Umbrella Roaming Client service. If the service is not running, it attempts to restart it and checks if the restart was successful.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  Displays the status of the Umbrella Roaming Client service and the result of the restart attempt.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  06/03/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Add logging or additional actions if the restart fails.
.EXAMPLE
  .\Check-UmbrellaService.ps1
#>

# Check if the Umbrella Roaming Client service is running
$service = Get-Service -Name "Umbrella_RC"

if ($service -ne $null -and $service.Status -eq "Running") {
    Write-Host "Umbrella Roaming Client is running"
}
else {
    Write-Host "Umbrella Roaming Client is not running"
    
    # Try to restart the Umbrella Roaming Client service
    Write-Host "Attempting to restart Umbrella Roaming Client service"
    Restart-Service -Name "Umbrella_RC" -Force
    
    # Check if the service started successfully after restart
    $service = Get-Service -Name "Umbrella_RC"
    if ($service -ne $null -and $service.Status -eq "Running") {
        Write-Host "Umbrella Roaming Client restarted successfully"
    }
    else {
        Write-Host "Failed to restart Umbrella Roaming Client"
        # Here you can add additional actions such as logging the failure or attempting a different action
    }
}
