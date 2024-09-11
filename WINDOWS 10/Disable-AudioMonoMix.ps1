<#
.SYNOPSIS
  Updates the audio settings to disable mono mix and restarts the audio service.
.DESCRIPTION
  This script modifies a registry value related to audio accessibility, then restarts the Windows audio service to apply the change.
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
  Requires:       Administrative privileges.

.EXAMPLE
  powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/s,/c,REG ADD \"HKCU\Software\Microsoft\Multimedia\Audio\" /V AccessibilityMonoMixState /T REG_DWORD /D 0 /F & net stop \"Audiosrv\" & net start \"Audiosrv\"' -Verb runAs"
#>

powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/s,/c,REG ADD \"HKCU\Software\Microsoft\Multimedia\Audio\" /V AccessibilityMonoMixState /T REG_DWORD /D 0 /F & net stop \"Audiosrv\" & net start \"Audiosrv\"' -Verb runAs"
