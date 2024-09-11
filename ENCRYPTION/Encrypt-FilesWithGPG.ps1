<#
.SYNOPSIS
  Encrypts files from a specified input folder and saves them to an output folder using GPG encryption.
.DESCRIPTION
  This script reads files from an input folder, encrypts them using a GPG key, and saves the encrypted files with the ".gpg" extension in an output folder. It utilises a public key file and a recipient's email address for encryption.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  None
.OUTPUTS
  Encrypted files with the ".gpg" extension are saved in the specified output folder.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  28 May 2023
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run this script to encrypt all files in the input folder and output the encrypted files in the designated output folder with ".gpg" extensions.
#>

# START OF SCRIPT

# DEFINE PATHS AND FILENAMES
$inputFolder = "C:\FOLDERA"  # DEMO INPUT FOLDER
$outputFolder = "C:\FOLDERB"  # DEMO OUTPUT FOLDER
$keyFolderPath = "C:\FOLDERC"  # DEMO KEY FOLDER
$keyFileName = "YOUR_KEY_HERE.asc"  # DEMO KEY FILENAME
$fileExtension = ".gpg"
$recipientKey = "DEMO@DEMO_EMAIL.COM"  # DEMO EMAIL FOR RECIPIENT
$encryptionKey = Get-Content (Join-Path $keyFolderPath $keyFileName)

# ENSURE THE OUTPUT FOLDER EXISTS
New-Item -ItemType Directory -Force -Path $outputFolder | Out-Null

# FULL PATH TO THE GPG EXECUTABLE
$gpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe"

# CREATE A TEMPORARY PASSPHRASE FILE
$passphraseFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $passphraseFile -Value $encryptionKey

# LOOP THROUGH EACH FILE IN THE INPUT FOLDER
Get-ChildItem -Path $inputFolder | ForEach-Object {
    # CONSTRUCT THE OUTPUT FILE PATH BY APPENDING THE ORIGINAL FILE EXTENSION
    $outputFile = Join-Path $outputFolder ($_.BaseName + $_.Extension + $fileExtension)

    # CONSTRUCT THE ARGUMENTS AS AN ARRAY OF STRINGS
    $arguments = @(
        "--batch",
        "--yes",
        "--passphrase-file", $passphraseFile,
        "--output", "$outputFile",
        "--encrypt",
        "--recipient", $recipientKey,
        "$($_.FullName)"
    )

    # OUTPUT INFORMATION FOR DEBUGGING
    Write-Host "PROCESSING FILE: $($_.FullName)"
    Write-Host "OUTPUT FILE: $outputFile"
    Write-Host "ARGUMENTS: $arguments"

    # RUN GPG WITHOUT REDIRECTION
    & $gpgPath $arguments

    # OPTIONAL: YOU CAN DELETE THE ORIGINAL FILE AFTER ENCRYPTION
    # Remove-Item $_.FullName
}

# REMOVE THE TEMPORARY PASSPHRASE FILE
Remove-Item $passphraseFile -Force

Write-Host "SCRIPT COMPLETED."

# END OF SCRIPT
