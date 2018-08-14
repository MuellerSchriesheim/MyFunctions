function Get-ServiceLogonAccount
<#
.SYNOPSIS
    Lists all services with the specified LogonAccount or without a paramter
    lists all serivice who are not localsystem or another NT Authority Service
.DESCRIPTION
    Lists all services with the specified LogonAccount or without a paramter
    lists all serivice who are not localsystem or another NT Authority Service
.EXAMPLE
    PS C:\> Get-ServiceLogonAccount
    Lists all Services from the Local Computer who are not LocalSystem or an NT Authority Service
.PARAMETER ComputerName
    The Computer(s) who are queried
.OUTPUTS
    [Microsoft.Management.Infrastructure.CimInstance]
.NOTES
    Author: Tobias Mueller
.FUNCTIONALITY
    Computers
#>
{
    [cmdletbinding()]

    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String[]]$ComputerName = "localhost",
        [System.String]$LogonAccount
    )

    process
    {
        foreach ($computer in $ComputerName) {
            if ($logonAccount)
            {
                $cimResult = Get-cimInstance -Class Win32_Service -ComputerName $computer -filter "startName LIKE '$LogonAccount'"
            }
            else
            {
                $cimResult = Get-cimInstance -Class Win32_Service -ComputerName $computer  -filter "NOT startName LIKE '%LocalSystem%' AND NOT startName LIKE 'NT%'"
            }
            $cimResult | Select-Object DisplayName, StartName, State
        }
    }
}