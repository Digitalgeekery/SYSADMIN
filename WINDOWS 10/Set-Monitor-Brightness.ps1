<#
.SYNOPSIS
  This script sets the brightness level of the monitor to a specified value.

.DESCRIPTION
  The script uses WMI (Windows Management Instrumentation) to adjust the monitor's brightness. The brightness is set to 85% with an immediate change.

.PARAMETER None
    This script does not require any parameters.

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  11/09/2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       None
  TODO:           None

.EXAMPLE
  Run the script to set the monitor's brightness to 85%. The brightness change is applied immediately.

#>

# SET MONITOR BRIGHTNESS TO 85%
(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,85)
