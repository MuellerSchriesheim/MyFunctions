
$ModuleName = "MyFunctions"

$LocalModulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"

Remove-Item -Path $LocalModulePath\$ModuleName -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

New-Item -Path $LocalModulePath\$ModuleName -Force -ItemType Directory | Out-Null

Copy-Item -Path .\$ModuleName -Destination $LocalModulePath -Recurse -Exclude "*TempPoint*" -Force -ErrorAction SilentlyContinue