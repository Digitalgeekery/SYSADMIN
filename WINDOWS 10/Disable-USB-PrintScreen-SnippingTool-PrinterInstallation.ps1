<#
.SYNOPSIS
  Disables various functionalities on the Windows system including USB mass storage, the Print Screen key, the Snipping Tool, and printer installation.
.DESCRIPTION
  This script modifies registry settings and system files to disable USB mass storage, the Print Screen key, the Snipping Tool, and the ability to add printers to the PC.
.PARAMETER None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Martin Doherty
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           Verify that the changes do not impact other functionalities adversely.

.EXAMPLE
  Run this script to apply restrictions on USB mass storage, Print Screen functionality, Snipping Tool, and printer installation.
#>

# Function to disable mass storage
Function DisableMassStorage {
    # Define the registry paths for USB storage
    $registryPaths = @(
        "HKLM:\SYSTEM\ControlSet001\services\USBSTOR",
        "HKLM:\SYSTEM\CurrentControlSet\services\USBSTOR",
        "HKLM:\SYSTEM\ControlSet002\services\USBSTOR"
    )

    # Disable USB storage devices for each ControlSet
    foreach ($path in $registryPaths) {
        if (Test-Path $path) {
            Set-ItemProperty -Path $path -Name "Start" -Value 4
            Write-Host "USB storage disabled for $path"
        } else {
            Write-Host "Registry path $path not found."
        }
    }
}

# Function to disable Print Screen key
Function DisablePrintScreen {
    # Define the registry path for Print Screen key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"

    # Set the Scancode Map value to disable Print Screen key
    New-ItemProperty -Path $registryPath -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]@(0,0,0,0,0,0,0,0,2,0,0,0,0,0,46,0,0,0,0,0))

    Write-Host "Print Screen key disabled."
}

# Function to disable Windows Snipping Tool
Function DisableSnippingTool {
    # Rename the executable for Snipping Tool
    Rename-Item -Path "$env:SystemRoot\System32\SnippingTool.exe" -NewName "SnippingTool_disabled.exe"

    Write-Host "Snipping Tool disabled."
}

# Function to disable printer installation
Function DisablePrinterInstallation {
    # Define the registry path for printer installation
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"

    # Create the Printers key if it doesn't exist
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Create a DWORD value named "DisableAddPrinter" and set it to 1 to disable printer installation
    Set-ItemProperty -Path $registryPath -Name "DisableAddPrinter" -Value 1

    Write-Host "Printer installation disabled."
}

# Call functions to disable mass storage, Print Screen key, Snipping Tool, and printer installation
DisableMassStorage
DisablePrintScreen
DisableSnippingTool
DisablePrinterInstallation

Write-Host "USB storage disabled, Print Screen key disabled, Snipping Tool disabled, and Printer installation disabled."
