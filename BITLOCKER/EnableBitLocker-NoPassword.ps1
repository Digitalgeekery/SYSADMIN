<#
.SYNOPSIS
  Enables BitLocker encryption on drive C: using AES256 encryption and skips the hardware test.
.DESCRIPTION
  This script turns on BitLocker encryption for the C: drive with AES256 encryption and bypasses the hardware test.
.PARAMETER None
.INPUTS
  NONE
.OUTPUTS
  Provides the status of the BitLocker encryption process.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Administrator privileges
  TODO:           Ensure the system meets the requirements for BitLocker encryption.
.EXAMPLE
  .\EnableBitLocker.ps1
  This example runs the script to enable BitLocker encryption on drive C:.
#>

# ENABLE BITLOCKER ENCRYPTION ON DRIVE C: WITH AES256 ENCRYPTION AND SKIP THE HARDWARE TEST
manage-bde -on C: -EncryptionMethod Aes256 -SkipHardwareTest
