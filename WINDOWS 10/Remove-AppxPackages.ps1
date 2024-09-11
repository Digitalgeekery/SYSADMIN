<#
.SYNOPSIS
  This script removes all provisioned app packages and app packages installed for all users.
.DESCRIPTION
  The script first removes all provisioned app packages from the system. It then removes app packages installed for all users, excluding system framework packages and certain pre-installed apps.
.PARAMETER None
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
  TODO:           Review and adjust exclusions as necessary for specific environments.

.EXAMPLE
  Run the script as an administrator to clean up app packages from the system.
#>

# Remove all provisioned app packages
Get-AppXProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online

# Remove all installed app packages for all users except system frameworks and certain pre-installed apps
Get-AppxPackage -allusers | % {
    if (!($_.IsFramework -or $_.PublisherId -eq "cw5n1h2txyewy")) {
        $_
    }
} | Remove-AppxPackage
