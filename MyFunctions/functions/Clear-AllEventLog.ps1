<#
	.SYNOPSIS
		Deletes all EventLogs on the Local Computer or a Remote Computer

	.DESCRIPTION
		Uses the wevtutil to delete all Log Files on the Local Host or a Remote Computer specified by the ComputerName Parameter

	.PARAMETER ComputerName
		A description of the ComputerName parameter.

	.EXAMPLE
				PS C:\> Clear-AllEventLogs

	.NOTES
		Additional information about the function.
#>
function Clear-AllEventLog
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            Position = 1)]
        [System.String[]]$ComputerName = "localhost"
    )

    process
    {
        try
        {
            Restart-ScriptAsADmin
            foreach ($Computer in $ComputerName)
            {
                #PowerShell script to clear ALL the Application and Service logs
                If ($Pscmdlet.ShouldProcess($Computer, "Lösche LogFiles"))
                {
                    wevtutil el /r:$Computer | ForEach-Object { wevtutil cl $_ /r:$Computer }

                }
            }
        }
        catch
        {
            Write-PSFMessage -Level Warning -Message "Löschen der Logs fehlgeschlagen $_"
        }
    }
}