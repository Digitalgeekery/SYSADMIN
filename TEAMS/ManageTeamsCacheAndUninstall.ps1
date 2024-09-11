<#
.SYNOPSIS
  Clears Microsoft Teams and web browsers' caches and optionally uninstalls Microsoft Teams.

.DESCRIPTION
  This script prompts the user to choose whether to clear the Teams cache, clear web browsers' caches, and/or uninstall Microsoft Teams. It stops relevant processes, clears caches for Microsoft Teams, Chrome, and Internet Explorer (IE), and removes Teams using the machine-wide installer or client installer if selected.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  Outputs messages indicating the success or failure of stopping processes, clearing caches, and uninstalling Microsoft Teams.

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  25/09/2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Ensure proper error handling and logging.

.EXAMPLE
  Run the script and follow prompts to clear Teams cache, clear web browsers' caches, and uninstall Microsoft Teams as needed.

#>

#START OF SCRIPT

$clearCache = Read-Host "Do you want to delete the Teams Cache (Y/N)?"
$clearCache = $clearCache.ToUpper()

$uninstall = Read-Host "Do you want to uninstall Teams completely (Y/N)?"
$uninstall = $uninstall.ToUpper()

if ($clearCache -eq "Y"){
    Write-Host "Stopping Teams Process" -ForegroundColor Yellow

    try {
        Get-Process -ProcessName Teams | Stop-Process -Force
        Start-Sleep -Seconds 3
        Write-Host "Teams Process Successfully Stopped" -ForegroundColor Green
    } catch {
        Write-Error $_
    }
    
    Write-Host "Clearing Teams Disk Cache" -ForegroundColor Yellow

    try {
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\application cache\cache | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\blob_storage | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\databases | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\cache | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\gpucache | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\Indexeddb | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\Local Storage | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\Microsoft\teams\tmp | Remove-Item -Confirm:$false
        Write-Host "Teams Disk Cache Cleaned" -ForegroundColor Green
    } catch {
        Write-Error $_
    }

    Write-Host "Stopping Chrome Process" -ForegroundColor Yellow

    try {
        Get-Process -ProcessName Chrome | Stop-Process -Force
        Start-Sleep -Seconds 3
        Write-Host "Chrome Process Successfully Stopped" -ForegroundColor Green
    } catch {
        Write-Error $_
    }

    Write-Host "Clearing Chrome Cache" -ForegroundColor Yellow
    
    try {
        Get-ChildItem -Path $env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies -File | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:LOCALAPPDATA\Google\Chrome\User Data\Default\Web Data -File | Remove-Item -Confirm:$false
        Write-Host "Chrome Cleaned" -ForegroundColor Green
    } catch {
        Write-Error $_
    }
    
    Write-Host "Stopping IE Process" -ForegroundColor Yellow
    
    try {
        Get-Process -ProcessName MicrosoftEdge | Stop-Process -Force
        Get-Process -ProcessName IExplore | Stop-Process -Force
        Write-Host "Internet Explorer and Edge Processes Successfully Stopped" -ForegroundColor Green
    } catch {
        Write-Error $_
    }

    Write-Host "Clearing IE Cache" -ForegroundColor Yellow
    
    try {
        RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
        RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2
        Write-Host "IE and Edge Cleaned" -ForegroundColor Green
    } catch {
        Write-Error $_
    }

    Write-Host "Cleanup Complete..." -ForegroundColor Green
}

if ($uninstall -eq "Y"){
    Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow
    $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Teams Machine-Wide Installer" }
    $MachineWide.Uninstall()

    function unInstallTeams($path) {
        $clientInstaller = "$($path)\Update.exe"
        
        try {
            $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction STOP

            if ($process.ExitCode -ne 0) {
                Write-Error "Uninstallation failed with exit code $($process.ExitCode)."
            }
        } catch {
            Write-Error $_.Exception.Message
        }
    }

    # Locate installation folder
    $localAppData = "$($env:LOCALAPPDATA)\Microsoft\Teams"
    $programData = "$($env:ProgramData)\$($env:USERNAME)\Microsoft\Teams"

    If (Test-Path "$($localAppData)\Current\Teams.exe") {
        unInstallTeams($localAppData)
    } elseif (Test-Path "$($programData)\Current\Teams.exe") {
        unInstallTeams($programData)
    } else {
        Write-Warning "Teams installation not found"
    }
}

#END OF SCRIPT
