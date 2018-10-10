<#
	.SYNOPSIS
		A brief description of the Export-ADUserToExcel function.

	.DESCRIPTION
		A detailed description of the Export-ADUserToExcel function.

	.PARAMETER ExportFolder
		A description of the ExportFolder parameter.

	.PARAMETER OnlyExport
		A description of the OnlyExport parameter.

	.EXAMPLE
		PS C:\> Export-ADUserToExcel

	.NOTES
		Additional information about the function.
#>
Function Export-ADUserToExcel
{
    [CmdletBinding(ConfirmImpact = 'None')]
    Param
    (
        [System.IO.DirectoryInfo]$ExportFolder,
        [Switch]$OnlyExport,
        [Switch]$NoExport,
        [Switch]$PassThru
    )

    Begin
    {
        If (!($ExportFolder))
        {
            $ExportFolder = Get-PSFConfigValue -FullName "myfunctions.aduserexport.exportpath"
        }
        If ([System.String]::IsNullOrEmpty($ExportFolder) -or $ExportFolder.Exists -eq $false)
        {
            Write-PSFMessage -Level Warning -Message "Der Exportpfad $ExportFolder existiert nicht. Bitte prüfen!"
            Throw "Der Exportpfad $ExportFolder existiert nicht. Bitte prüfen!"
        }
    }

    Process
    {

        $Params = @{
            Property = 'SamAccountName as Login',
            'CN as Anzeigename',
            'GivenName as Vorname',
            'sn as Nachname',
            'department as Abteilung',
            'Title as Funktion',
            'telephoneNumber as Telefon',
            'mobile as Mobil',
            'facsimileTelephoneNumber as Fax',
            'pager as FaxAbteilung',
            'physicalDeliveryOfficeName as Raum',
            'mail as eMail',
            'description as Beschreibung',
            'Company as Firma',
            'l as Ort',
            'PostalCode as PLZ',
            'StreetAddress as Strasse',
            'HomeDirectory as HomeDir',
            'HomeDrive as HomeDrive',
            'Info as Anmerkung'
        }

        $filterStrings = @()
        $filterStrings += "givenname -like '*'"
        # $filterStrings += "-not (info -like '*##NO_TELEFON_LIST##*')"
        $filter = $filterStrings -join " -and "

        $Date = Get-Date -Format 'yyyyMMdd-HHmmss'
        $exportPath = Join-Path -Path $exportFolder -ChildPath "$Date-ADUserExport.xlsx"

        $adUsers = Get-ADUser -Properties * -Filter $filter | Sort-Object -Property CN | Select-PSFObject @Params

        $paramExportExcel = @{
            Path               = $exportPath
            WorkSheetname      = "ADUser"
            TableName          = "ADUser"
            Show               = (!($OnlyExport))
            AutoSize           = $true
            FreezeTopRow       = $true
            NoNumberConversion = '*'
        }


        if (-not($NoExport))
        {
            $adUsers | Export-Excel @paramExportExcel
        }

        if ($PassThru)
        {
            $adUsers
        }

    }
}