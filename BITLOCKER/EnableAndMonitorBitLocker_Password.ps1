<#
.SYNOPSIS
  Enables BitLocker encryption on a specified drive with a password and monitors the encryption progress.
.DESCRIPTION
  This script enables BitLocker on the C: drive using a password provided by the user. It also adds a recovery key protector, monitors the encryption progress, and displays the recovery password for each volume once encryption is complete. The execution policy is set to RemoteSigned.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  User input for the BitLocker password.
.OUTPUTS
  Status messages and progress of the encryption process, and the recovery password for each BitLocker volume.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  18 June 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script to enable BitLocker on drive C: with a password, monitor encryption progress, and display recovery keys for BitLocker volumes.
#>

# START OF SCRIPT

# PROMPT USER FOR BITLOCKER PASSWORD AND CONVERT TO SECURE STRING
$Pass = Read-Host -Prompt "ENTER PASSWORD FOR BITLOCKER" | ConvertTo-SecureString -AsPlainText -Force

# ENABLE BITLOCKER WITH PASSWORD PROTECTOR
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -SkipHardwareTest -PasswordProtector -Password $Pass 

# ADD A RECOVERY KEY PROTECTOR
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryKeyPath "E:\keys\" -RecoveryKeyProtector

# MONITOR ENCRYPTION PROGRESS UNTIL COMPLETED
DO {
    $Volume = Get-BitLockerVolume -MountPoint C:
    Write-Progress -Activity "Encrypting volume $($Volume.MountPoint)" -Status "Encryption Progress:" -PercentComplete $Volume.EncryptionPercentage
    Start-Sleep -Seconds 1
} UNTIL ($Volume.VolumeStatus -eq 'FullyEncrypted')

Write-Progress -Activity "Encrypting volume $($Volume.MountPoint)" -Status "Encryption Progress:" -Completed

# WAIT FOR 3 SECONDS
timeout 3

# SET EXECUTION POLICY TO REMOTESIGNED
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# GET ALL BITLOCKER VOLUMES AND DISPLAY RECOVERY PASSWORDS
$BitlockerVolumes = Get-BitLockerVolume

# FOR EACH VOLUME, GET THE RECOVERY PASSWORD AND DISPLAY IT
$BitlockerVolumes |
    ForEach-Object {
        $MountPoint = $_.MountPoint 
        $RecoveryKey = [string]($_.KeyProtector).RecoveryPassword       
        IF ($RecoveryKey.Length -gt 5) {
            Write-Output ("The drive $MountPoint has a recovery key $RecoveryKey.")
        }        
    }

# END OF SCRIPT
