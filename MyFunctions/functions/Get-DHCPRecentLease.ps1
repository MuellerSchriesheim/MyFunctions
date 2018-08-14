<#
	.SYNOPSIS
		Gets the Last x Leases from a specific Scope

	.DESCRIPTION
		A detailed description of the Get-DHCPRecentLease function.

	.PARAMETER ScopeID
		IP Adress of the DHCP Scope

	.PARAMETER ComputerName
		Name of the DHCP Server

	.PARAMETER Items
		Specify the Last x Items to show

	.EXAMPLE
				PS C:\> Get-DHCPRecentLease

	.NOTES
		Additional information about the function.
#>
function Get-DHCPRecentLease
{
    [CmdletBinding()]
    param
    (
        [IPaddress]$ScopeID,
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [System.String[]]
        $ComputerName,
        [int]$Items = 5
    )

    if (!($ComputerName))
    {
        $ComputerName = $(Get-PSFConfig -Module "MyFunctions" -Name "DHCP.FQDN").Value
    }

    foreach ($computer in $ComputerName)
    {
        if ($ScopeID)
        {
            Get-DhcpServerv4Scope -ComputerName $computer -ScopeId $ScopeID| Get-DhcpServerv4Lease -ComputerName $computer | Sort-Object LeaseExpiryTime | Select-Object -Last $Items
        }
        else
        {
            Get-DhcpServerv4Scope -ComputerName $computer| Get-DhcpServerv4Lease -ComputerName $computer | Sort-Object LeaseExpiryTime | Select-Object -Last $Items
        }
    }
}