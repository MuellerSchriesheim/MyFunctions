function Update-PSFConfig
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleName,
        [Switch]
        $NoConfigFile
    )
    begin
    {
        [bool]$settingsChanged = $false
        $configPath = "$($(Get-PSFConfig -Module 'Schriesheim-IT' -Name 'ConfigurationRepository').Value)\$ModuleName\$ModuleName.json"
        Write-PSFMessage -Level SomewhatVerbose -Message "Check for existing Config File in central Repository: $configPath"
        if (Test-Path -Path $configPath)
        {
            # Normally when the Module is loaded the settings should already be loaded via the configuration.ps1
            # Just too double check we'll load the config explicitly if it exists
            Write-PSFMessage -Level SomewhatVerbose -Message "Import Config from: $configPath"
            Import-PSFConfig -Path $configPath
        }
    }
    process
    {
        $configSettings = Get-PSFConfig -Module $ModuleName
        foreach ($setting in $configSettings)
        {
            Write-PSFMessage -Level Host -Message "Setting: $($setting.Name)"
            Write-PSFMessage -Level Host -Message "Description: $($setting.Description)"
            $NewValue = Read-Host -Prompt "New Value [$($setting.value)]"
            if ($NewValue -ne '')
            {
                Set-PSFConfig -Module $setting.Module -Name $setting.Name -Value $NewValue
                [bool]$settingsChanged = $true
            }
        }
    }
    end
    {
        Write-PSFMessage -Level Host -Message "New Settings for Module $ModuleName"
        Get-PSFConfig -Module $ModuleName
        if (!($NoConfigFile) -and $settingsChanged)
        {
            Write-PSFMessage -Level SomewhatVerbose -Message "Export Config to: $configPath"
            Export-PSFConfig -Module $ModuleName -OutPath $configPath
        }
    }


}