function Save-PSFConfig
{
    [CmdletBinding()]
    param (
        [System.String]
        $ModuleName
    )
    begin
    {
        $OutPath = "$($(Get-PSFConfig -Module 'Schriesheim-IT' -Name 'ConfigurationRepository').Value)\$ModuleName\$ModuleName.json"
    }
    process
    {
        Export-PSFConfig -Module $ModuleName -OutPath $OutPath
    }


}