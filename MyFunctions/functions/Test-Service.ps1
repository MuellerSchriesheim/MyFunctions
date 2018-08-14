function Test-Service
{
    <#
.SYNOPSIS
	Test if a service is running. If not the function will try to restart the service.
.DESCRIPTION
Test if a service is running. If not the function will try to restart the service.
.EXAMPLE
	PS C:\> Test-Service -ServiceName Server
	Explanation of what the example does
.INPUTS
	Inputs (if any)
.OUTPUTS
	Output (if any)
.NOTES
	General notes
#>
    param
    (
        [Parameter(Mandatory = $true,
            Position = 1)]
        [String]$ServiceName,
        [Parameter(Mandatory = $false,
            Position = 2)]
        [String[]]$ComputerName = 'localhost',
        [int]$timeOut = 5
    )
    process
    {
        forEach ($computer in $ComputerName)
        {
            $Service = Get-Service -Name $ServiceName -ComputerName $Computer

            Write-PSFMessage -Level Host -Message "Der Status des Dienst $ServiceName auf dem Server $Computer ist $($Service.Status)"

            if ($Service.Status -ne 'Running')
            {
                Write-PSFMessage -Level Host -Message "Es wird versucht den Dienst zu Starten"
                $Service | Start-Service
                Start-Sleep -Seconds $timeOut
                $Service = Get-Service -Name $ServiceName -ComputerName $Computer
                Write-PSFMessage -Level Host -Message "Der Status des Dienst $ServiceName auf dem Server $Computer ist $($Service.Status)"
            }
        }
    }
}