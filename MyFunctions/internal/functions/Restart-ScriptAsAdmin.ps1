function Restart-ScriptAsAdmin
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Only Restarts a Script")]
    [CmdletBinding(SupportsShouldProcess = $false)]
    param()

    process
    {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
        $Invocation = ((Get-Variable MyInvocation).value).ScriptName
        if ($null -eq $Invocation -or $currentPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ) ) {return}
        Start-Process "$psHome\powershell.exe" -Verb Runas -ArgumentList ("-command `"'" + $Invocation + "'`"")
        break
    }

}