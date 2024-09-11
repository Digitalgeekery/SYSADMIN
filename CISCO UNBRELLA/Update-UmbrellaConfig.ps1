<#
.SYNOPSIS
  Creates or updates a JSON configuration file for Cisco Umbrella.
.DESCRIPTION
  This script ensures that the directory for the configuration file exists and then writes a JSON file with specified content to that directory. If the file already exists, it will be overwritten.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  A JSON file at the specified path with the configuration content.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  08/03/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None
.EXAMPLE
  .\Update-UmbrellaConfig.ps1
#>

# Define the file path
$filePath = "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Umbrella\config.json"

# Ensure the directory exists, create it if it doesn't
$directory = [System.IO.Path]::GetDirectoryName($filePath)
if (-not (Test-Path $directory)) {
    New-Item -Path $directory -ItemType Directory -Force
}

# Define the content to write to the JSON file
$jsonContent = @"
{
    "organizationId" : "123456789",
    "fingerprint" : "123456789",
    "userId" : "123456789"
}
"@

# Write the content to the file, overwriting any existing file
$jsonContent | Out-File -FilePath $filePath -Encoding utf8 -Force
