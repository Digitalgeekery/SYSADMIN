<#
.SYNOPSIS
  Performs a traceroute to a specified IP address or domain and logs the results to a text file.
.DESCRIPTION
  This script executes a traceroute command to a given IP address or domain, logs the results, and saves them to a text file with a timestamp.
.PARAMETER None
.INPUTS
  NONE
.OUTPUTS
  A text file containing the traceroute results. Example: C:\test\TracertOutput_<formatted_date>.txt
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None
.EXAMPLE
  .\TracerouteLog.ps1
  This example runs the script to perform a traceroute and log results to a file.
#>

# DEFINE THE IP ADDRESS OR DOMAIN TO BE TRACED
$destination = "203.0.113.1"  # Replace with your actual IP address or domain for testing

# GET THE CURRENT DATE AND TIME
$startDate = Get-Date

# FORMAT THE START DATE AND TIME
$formattedStartDate = $startDate.ToString("ddd dd MMM yyyy HH-mm-ss")

# SPECIFY THE DIRECTORY WHERE YOU WANT TO SAVE THE TEXT FILE
$filePath = "C:\test\"

# CHECK IF THE DIRECTORY EXISTS, IF NOT, CREATE IT
if (-not (Test-Path -Path $filePath)) {
    New-Item -Path $filePath -ItemType Directory -Force
}

# DEFINE THE FILENAME WITH THE FORMATTED START DATE AND TIME
$fileName = "TracertOutput_$formattedStartDate.txt"

# COMBINE THE FILE PATH AND FILENAME
$outputFilePath = Join-Path -Path $filePath -ChildPath $fileName

# WRITE THE START DATE AND TIME TO THE OUTPUT FILE
@"
Start Date and Time: $formattedStartDate
===========================================
"@ | Out-File -FilePath $outputFilePath -Encoding utf8

# PERFORM THE TRACEROUTE AND APPEND THE OUTPUT TO THE OUTPUT FILE
tracert -d $destination | Out-File -FilePath $outputFilePath -Append -Encoding utf8

# DISPLAY A MESSAGE INDICATING THE TRACEROUTE OPERATION IS COMPLETED
Write-Host "Traceroute operation completed. Output saved to $outputFilePath"
