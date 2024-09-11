<#
.SYNOPSIS
  Enables BitLocker encryption on the C: drive with a password derived from the MAC address of a specified network adapter and displays relevant information.
.DESCRIPTION
  This script enables BitLocker encryption on the C: drive using a password generated from the MAC address of a selected network adapter. It adds a recovery key protector and monitors the encryption progress. The script displays the BitLocker password and computer name in the console.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  User input for the network adapter index.
.OUTPUTS
  Status messages, encryption progress, and the BitLocker password.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  30 August 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script to enable BitLocker on drive C: with a password based on the MAC address of a specified network adapter and to display the relevant information.
#>

# START OF SCRIPT

# OUTPUT EMPTY LINES FOR VISUAL SEPARATION
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""

# DISPLAY SECTION HEADER
Write-Host "================ BITLOCKER ENCRYPTION ================"

# OUTPUT EMPTY LINES FOR VISUAL SEPARATION
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""

# GET NETWORK ADAPTER INFORMATION
Get-NetAdapter

# OUTPUT EMPTY LINES FOR VISUAL SEPARATION
Write-Output ""
Write-Output ""

# PROMPT USER FOR NETWORK ADAPTER INDEX
$nicno = Read-Host -Prompt "ENTER WIFI INDEX NUMBER"

# OUTPUT EMPTY LINES FOR VISUAL SEPARATION
Write-Output ""
Write-Output ""

# DISPLAY COMPUTER NAME AND BITLOCKER PASSWORD
Write-Host " COMPUTER NAME = UKHW-$ComputerName" -ForegroundColor GREEN
Write-Host "BITLOCKER PASSWORD = ukhw$(Get-NetAdapter -InterfaceIndex $nicno).MacAddress.Replace('-','').Substring(8,4).ToLower()" -ForegroundColor GREEN 

# SET BITLOCKER PASSWORD
$Pass = "$("ukhw")$((Get-NetAdapter -InterfaceIndex $nicno).MacAddress.Replace('-','').Substring(8,4))".ToLower() | ConvertTo-SecureString -AsPlainText -Force

# ENABLE BITLOCKER ENCRYPTION
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -SkipHardwareTest -PasswordProtector -Password $Pass 
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryKeyPath "E:\keys\" -RecoveryKeyProtector

# MONITOR ENCRYPTION PROGRESS
do {
    $Volume = Get-BitLockerVolume -MountPoint C:
    Write-Progress -Activity "Encrypting volume $($Volume.MountPoint)" -Status "Encryption Progress:" -PercentComplete $Volume.EncryptionPercentage
    Start-Sleep -Seconds 1
} until ($Volume.VolumeStatus -eq 'FullyEncrypted')

Write-Progress -Activity "Encrypting volume $($Volume.MountPoint)" -Status "Encryption Progress:" -Completed

# DISPLAY FINAL COMPUTER NAME AND BITLOCKER PASSWORD
Write-Host "COMPUTER NAME = UKHW-$ComputerName" -ForegroundColor GREEN
Write-Host "BITLOCKER PASSWORD = ukhw$(Get-NetAdapter -InterfaceIndex $nicno).MacAddress.Replace('-','').Substring(8,4).ToLower()" -ForegroundColor GREEN 

# END OF SCRIPT
