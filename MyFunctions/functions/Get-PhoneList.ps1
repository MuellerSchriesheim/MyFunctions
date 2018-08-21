Function Get-PhoneList
{
    [CmdletBinding()]
    param ()

    begin
    {

        If (!(Get-iDoitInfo))
        {
            $ComputerName = Get-PSFConfigValue -FullName "psidoit.idoit.server"
            $ApiKey = Get-PSFConfigValue -FullName  "psidoit.idoit.apikey"
            $User = Get-PSFConfigValue -FullName  "psidoit.idoit.user"

            Initialize-idoit -Server $ComputerName -Credentials $User -ApiKey $ApiKey
        }
        $LocalPath = Get-PSFConfigValue -FullName "myfunctions.phonelist.exportpath"
    }

    process
    {
        $longList = Get-iDoitReport -ReportID 46 | Sort-Object -Property Nachname, Vorname
        $widgetList = $longList | Select-Object -Property Nachname, Vorname, Telefon, Handy, Abteilung, Einrichtung

        $localPathDefaultList = Join-Path $LocalPath -ChildPath "idoit_telefonliste_default.csv"
        $longList | Export-Csv -Path $localPathDefaultList -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Force
        $localPathWidgetList = Join-Path $LocalPath -ChildPath "idoit_telefonliste_widget.csv"
        $widgetList | Export-Csv -Path $localPathWidgetList -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Force
    }
}