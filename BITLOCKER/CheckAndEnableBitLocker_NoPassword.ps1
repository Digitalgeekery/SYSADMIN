<#
.SYNOPSIS
  Checks if BitLocker is enabled on a specified drive and enables it if not.
.DESCRIPTION
  This script checks the BitLocker status of the specified drive. If BitLocker is not enabled, it enables BitLocker with specific settings and saves the recovery key to a designated path. If BitLocker is already enabled or not supported, it provides appropriate messages.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  Status messages indicating whether BitLocker was enabled, already enabled, or not supported.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  15 June 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run the script to check and enable BitLocker on drive C: if it is not already enabled.
#>

# START OF SCRIPT

# DEFINE THE DRIVE LETTER
$drive = "C:"  # CHANGE THIS TO THE APPROPRIATE DRIVE LETTER

# CHECK IF BITLOCKER IS ENABLED ON THE DRIVE
$bitlockerStatus = Get-BitLockerVolume -MountPoint $drive

IF ($bitlockerStatus.ProtectionStatus -eq "Off") {
    # ENABLE BITLOCKER WITHOUT A PASSWORD
    ENABLE-BITLOCKER -MOUNTPOINT $drive -SKIPHARDWARETEST -USEDSPACEONLY -ENCRYPTIONMETHOD Aes256 -RECOVERYKEYPATH "C:\Windows\Temp" -CONFIRM:$false
    WRITE-HOST "BITLOCKER HAS BEEN ENABLED ON DRIVE $drive WITHOUT A PASSWORD."
} ELSEIF ($bitlockerStatus.ProtectionStatus -eq "On") {
    WRITE-HOST "BITLOCKER IS ALREADY ENABLED ON DRIVE $drive."
} ELSE {
    WRITE-HOST "BITLOCKER IS NOT SUPPORTED ON DRIVE $drive."
}

# END OF SCRIPT
