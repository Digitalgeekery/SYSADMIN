<#
.SYNOPSIS
  Performs a series of ping tests to a specified IP address and logs the results to a text file.
.DESCRIPTION
  This script pings a specified IP address multiple times, logs the results including any timeout or unreachable messages, and saves the output to a text file with a timestamp.
.PARAMETER None
.INPUTS
  NONE
.OUTPUTS
  A text file containing the ping results and summary statistics. Example: C:\test\PingOutput_<formatted_date>.txt
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None
.EXAMPLE
  .\PingTestAndLog.ps1
  This example runs the script to ping the IP address and log results to a file.
#>

# DEFINE THE IP ADDRESS TO BE PINGED
$ipAddress = "192.168.1.1"  # Replace with your actual IP address for testing

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
$fileName = "PingOutput_$formattedStartDate.txt"

# COMBINE THE FILE PATH AND FILENAME
$outputFilePath = Join-Path -Path $filePath -ChildPath $fileName

# WRITE THE START DATE AND TIME TO THE OUTPUT FILE
@"
Start Date and Time: $formattedStartDate
===========================================
"@ | Out-File -FilePath $outputFilePath -Encoding utf8

# DEFINE THE NUMBER OF PING REQUESTS
$pingCount = 10

# LOOP THROUGH THE PING REQUESTS
for ($i = 1; $i -le $pingCount; $i++) {
    # PING THE IP ADDRESS WITH 1 ECHO REQUEST AND CAPTURE ONLY THE RESULT
    $pingResult = (ping -n 1 $ipAddress | Select-String "Reply from", "Request timed out", "Destination host unreachable").Line
    # OUTPUT THE PING RESULT TO THE OUTPUT FILE
    $pingResult | Out-File -FilePath $outputFilePath -Append -Encoding utf8

    # DISPLAY THE COUNTER
    Write-Host "Ping request $i/$pingCount"
}

# GET THE SUMMARY STATISTICS FOR ALL PING REQUESTS
ping $ipAddress -n $pingCount | Select-String "Packets: Sent" | Out-File -FilePath $outputFilePath -Append -Encoding utf8

# DISPLAY A MESSAGE INDICATING THE PING OPERATION IS COMPLETED
Write-Host "Ping operation completed. Output saved to $outputFilePath"
