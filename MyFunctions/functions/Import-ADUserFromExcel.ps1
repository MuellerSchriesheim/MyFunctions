Function Import-ADUserFromExcel
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Test-PSFShouldProcess is used instead of ShouldProcess.")]
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess = $true)]
    Param
    (
        [System.IO.FileInfo]$ImportFile,
        [Switch]$OnlyExport,
        [Switch]$NoExport
    )

    Begin
    {
        $WhatIfPreference = $false
        Set-PSFConfig -Module 'MyFunctions' -Name 'ADUserExport.ImportFile' -Value '\\file-a\edv\EDV\PowerShellData\ADUserExport\AD_ImportFile.xlsx' -Validation 'String' -Handler { } -Description "Pfad zur Import Datei für den AD User Import" -ModuleExport
        Function Compare-ObjectProperties
        {
            Param(
                [PSObject]$ReferenceObject,
                [PSObject]$DifferenceObject
            )
            $objprops = $ReferenceObject | Get-Member -MemberType Property, NoteProperty | % Name
            $objprops += $DifferenceObject | Get-Member -MemberType Property, NoteProperty | % Name
            $objprops = $objprops | Sort | Select -Unique
            $diffs = @()
            foreach ($objprop in $objprops)
            {
                $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop
                if ($diff)
                {
                    $diffprops = @{
                        PropertyName = $objprop
                        RefValue     = ($diff | ? {$_.SideIndicator -eq '<='} | % $($objprop))
                        DiffValue    = ($diff | ? {$_.SideIndicator -eq '=>'} | % $($objprop))
                    }
                    $diffs += New-Object PSObject -Property $diffprops
                }
            }
            if ($diffs) {return ($diffs | Select PropertyName, RefValue, DiffValue)}
        }


        If (!($ImportFile))
        {
            $ImportFile = Get-PSFConfigValue -FullName "myfunctions.aduserexport.importfile"
        }
        If ([System.String]::IsNullOrEmpty($ImportFile) -or $ImportFile.Exists -eq $false)
        {
            Write-PSFMessage -Level Warning -Message "Die Importdatei $ImportFile existiert nicht. Bitte prüfen!"
            Throw "Die Importdatei $ImportFile existiert nicht. Bitte prüfen!"
        }

        $WorkSheetName = "ADUser"

        $importedUsers = Import-Excel -Path $ImportFile -WorksheetName $WorkSheetName  | Sort-Object -Property Anzeigename
        $currentUsers = Export-ADUserToExcel -NoExport -PassThru | Sort-Object -Property Anzeigename
    }

    process
    {
        $changes = @()
        foreach ($user in $importedUsers)
        {
            #Read-Host ($User.login)
            $Diff = Compare-ObjectProperties $user ($currentUsers | Where-Object {$_.Login -eq $user.Login})
            $changes += $Diff | Select-PSFObject 'Login from User', 'PropertyName as Eigenschaft', 'RefValue as NeuerWert', 'DiffValue as AlterWert'
        }

        if ($changes.Count -gt 0)
        {
            $message = @"
Folgende Änderungen werden am Active Directory vorgenommen:
$($changes | Format-Table -AutoSize | Out-String)
"@

            $question = 'Sollen die Änderungen am Active Directory durchgeführt werden?'
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
            if ($decision -eq 0)
            {
                foreach ($user in $importedUsers | Where-Object {$changes.Login -contains $_.Login})
                {
                    Write-PSFMessage -Level Verbose -Message "Ändere User $($user.Anzeigename)"
                    $Params = @{
                        Identity      = $user.Login
                        DisplayName   = $User.Anzeigename
                        GivenName     = $User.Vorname
                        Surname       = $User.Nachname
                        Department    = $User.Abteilung
                        Title         = $user.Funktion
                        OfficePhone   = $User.Telefon
                        MobilePhone   = $User.Mobil
                        Fax           = $user.Fax
                        Office        = $user.Raum
                        EmailAddress  = $User.eMail
                        Description   = $User.Beschreibung
                        Company       = $User.Firma
                        City          = $User.Ort
                        PostalCode    = $user.PLZ
                        StreetAddress = $user.Strasse
                        HomeDirectory = $User.HomeDir
                        HomeDrive     = $user.HomeDrive
                        # Replace is used for all properties that cannot be modfied using a Cmdlet Parameter
                    }
                    #Manager = $user.Manager
                    if ($User.Anmerkung)
                    {
                        $Params += @{
                            Replace = @{
                                info = $user.Anmerkung
                            }
                        }
                    }

                    if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $user.login -Action 'Aktualisiere User')
                    {
                        Set-ADUser @Params
                    }
                    else
                    {
                        Write-PSFMessage -Level Verbose -Message "Folgende Änderungen wären vorgenommen worden:"
                        Write-PSFMessage -Level Verbose -Message $($changes | Where-Object {$_.Login -eq $user.login}| Format-Table | Out-String)
                    }
                }
            }
        }
        else
        {
            Write-PSFMessage -Level Host -Message "Es gibt keine Abweichungen zwischen der Importdatei und dem Active Directory"
            Write-PSFMessage -Level Host -Message "Es sind keine Änderungen notwendig."
        }
    }
}