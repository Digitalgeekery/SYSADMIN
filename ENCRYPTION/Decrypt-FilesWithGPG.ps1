<#
.SYNOPSIS
  Decrypts GPG-encrypted files from a specified input folder and saves them to an output folder.
.DESCRIPTION
  This script reads GPG-encrypted files from an input folder, decrypts them using a private key, and saves the decrypted files to an output folder. It uses a specified private key file for the decryption process.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  Encrypted files with the ".gpg" extension from the input folder.
.OUTPUTS
  Decrypted files saved in the output folder with the ".gpg" extension removed.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  29 April 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT

.EXAMPLE
  Run this script to decrypt all GPG-encrypted files in the input folder and save the decrypted files to the designated output folder.
#>

# START OF SCRIPT

# DEFINE PATHS AND FILENAMES
$inputFolder = "C:\FOLDERB"  # DEMO INPUT FOLDER
$outputFolder = "C:\FOLDERD"  # DEMO OUTPUT FOLDER
$keyFolderPath = "C:\FOLDERC"  # DEMO KEY FOLDER
$keyFileName = "YOUR_KEY_HERE.asc"  # DEMO KEY FILENAME
$fileExtension = ".gpg"

# FULL PATH TO THE GPG EXECUTABLE
$gpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe"

# ENSURE THE OUTPUT FOLDER EXISTS
New-Item -ItemType Directory -Force -Path $outputFolder | Out-Null

# DEFINE THE PRIVATE KEY FILE
$privateKeyFile = Join-Path $keyFolderPath $keyFileName

# LOOP THROUGH EACH ENCRYPTED FILE IN THE INPUT FOLDER
Get-ChildItem -Path $inputFolder -Filter "*$fileExtension" | ForEach-Object {
    # CONSTRUCT THE OUTPUT FILE PATH BY REMOVING THE ENCRYPTION FILE EXTENSION
    $outputFile = Join-Path $outputFolder ($_.BaseName + $_.Extension -replace [regex]::Escape($fileExtension), "")

    # CONSTRUCT THE ARGUMENTS AS AN ARRAY OF STRINGS
    $arguments = @(
        "--batch",
        "--yes",
        "--decrypt",
        "--output", "$outputFile",
        "--secret-keyring", $privateKeyFile,
        "$($_.FullName)"
    )

    # OUTPUT INFORMATION FOR DEBUGGING
    Write-Host "PROCESSING FILE: $($_.FullName)"
    Write-Host "OUTPUT FILE: $outputFile"
    Write-Host "ARGUMENTS: $arguments"

    # RUN GPG WITHOUT REDIRECTION
    & $gpgPath $arguments

    # OPTIONAL: YOU CAN DELETE THE ENCRYPTED FILE AFTER DECRYPTION
    # Remove-Item $_.FullName
}

Write-Host "DECRYPTION SCRIPT COMPLETED."

# END OF SCRIPT
