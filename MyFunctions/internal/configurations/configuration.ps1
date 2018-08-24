<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'bConnect' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

#Path to an Configuration JSON File
$ConfigurationFile = "$($(Get-PSFConfig -Module 'Schriesheim-IT' -Name 'ConfigurationRepository').Value)\MyFunctions\MyFunctions.json"

Set-PSFConfig -Module 'MyFunctions' -Name 'DHCP.FQDN' -Value '' -Initialize -Validation 'String' -Handler { } -Description "DHCP Server der per Get-DHCPRecentLease abgefragt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'IMC.FQDN' -Value '' -Initialize -Validation 'String' -Handler { } -Description "IMC Server der per Get-ImcSwitchPort abgefragt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'SMTP.From' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Absender Adresse die bei der Nutzung von Send-MailMessage in verschiedenen CmdLets genutzt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'SMTP.Server' -Value '' -Initialize -Validation 'String' -Handler { } -Description "SMTP Server der bei der Nutzung von Send-MailMessage von verschiedenen CmdLets genutzt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'PhoneList.ExportPath' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Pfad unter dem die Telefonlisten Exporte von iDoit abgelegt werden" -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'PhoneList.RemotePath' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Remotepfad unter dem die Telefonlisten Exporte hochgeladen werden" -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'PhoneList.RemoteServer' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Intranetserver auf dem die Telefonliste veröffentlicht wird" -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'PhoneList.KeyFile' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Pfad zur OpenSSH Schlüsseldatei die für die SSH Verbindung genutzt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'PhoneList.SSHUser' -Value '' -Initialize -Validation 'String' -Handler { } -Description "User der für die SSH Verbindung genutzt wird." -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'ADUserExport.ExportPath' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Pfad unter dem die XLS Dateien der AD User Exporte abgelegt werden" -ModuleExport
Set-PSFConfig -Module 'MyFunctions' -Name 'ADUserExport.ImportFile' -Value '' -Initialize -Validation 'String' -Handler { } -Description "Pfad zur Import Datei für den AD User Import" -ModuleExport

If ($ConfigurationFile)
{
    Import-PSFConfig -Path $ConfigurationFile
}
