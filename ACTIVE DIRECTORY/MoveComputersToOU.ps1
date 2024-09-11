<#
.SYNOPSIS
  Moves computers from their current Active Directory Organizational Unit (OU) to a specified target OU.
.DESCRIPTION
  This script reads a list of computer names from a text file and attempts to move each computer to the specified target OU. It handles errors gracefully and provides feedback on the success or failure of each operation.
.PARAMETER None
    No parameters are required for this script.
.INPUTS
  A text file located at C:\hostnames.txt containing a list of computer names (one per line).
.OUTPUTS
  Status messages indicating whether each computer was successfully moved or if an error occurred.
.NOTES
  Version:        1.0
  Author:         DIGITALGEEKERY
  Creation Date:  17 February 2024
  Purpose/Change: INITIAL SCRIPT DEVELOPMENT
  Requires:       Active Directory module

.EXAMPLE
  Run the script in a PowerShell environment with appropriate permissions to move computers between OUs. Ensure that C:\hostnames.txt exists and contains the list of computer names to be moved.
#>

# START OF SCRIPT

# DEFINE THE TARGET ORGANIZATIONAL UNIT (OU)
$TargetOU = "OU=DemoOU,DC=demoDomain,DC=com"  # DEMO DATA

# READ COMPUTER NAMES FROM THE TEXT FILE
$ADComputers = Get-Content -Path "C:\hostnames.txt"

# LOOP THROUGH EACH COMPUTER NAME AND MOVE TO THE TARGET OU
foreach ($computerName in $ADComputers) { 

    try { 

        # GET THE CURRENT COMPUTER OBJECT
        if (($currentComputer = Get-ADComputer -Identity $computerName -ErrorAction Stop)) { 

            # MOVE THE COMPUTER OBJECT TO THE TARGET OU
            Move-ADObject -Identity $currentComputer -TargetPath $TargetOU -ErrorAction Stop 

            # OUTPUT SUCCESS MESSAGE
            "OKAY: Moved $($computerName) to $TargetOU" | Out-Default 

        } 

    } 

    catch { 

        # OUTPUT ERROR MESSAGE
        "FAIL: $($_.Exception.Message)" | Out-Default 

    } 

}

# END OF SCRIPT
