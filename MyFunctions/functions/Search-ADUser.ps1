<#
	.SYNOPSIS
		Durchsucht das AD nach dem übergebenen Displaynamen

	.DESCRIPTION
		Durchsucht das AD nach dem übergebenen Displaynamen

	.PARAMETER Displayname
		Anzeigename des Kontakt

	.PARAMETER Nachname
		Nachname des Kontaktes

	.PARAMETER eMail
		eMail Adresse des Kontaktes

	.EXAMPLE

	.NOTES
		Author: Tobias Müller
#>
function Search-ADUser
{
    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $false)]
    param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [String]$Displayname
    )

    $Displayname = "*$Displayname*"

    Get-ADUser -Filter { displayName -like $Displayname -and SamAccountName -notlike "admin-*" -and Enabled -eq $True } -Properties SamAccountName, GivenName, Surname, telephoneNumber, mail, MobilePhone, Department | Sort-Object Surname, GivenName | Select-Object Name, SamAccountName, Mail, telephoneNumber, MobilePhone, Department | Write-Output
}

New-Alias -Name sAD -Value Search-ADUser