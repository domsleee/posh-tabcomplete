$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

if ($(Get-ExperimentalFeature "PSNativeCommandErrorActionPreference").Enabled -ne $true) {
    Write-Error @'
PSNativeCommandErrorActionPreference (pwsh 7.3 feature) must be enabled to run this script, so that if git.exe fails, the script will STOP
refer to https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3
Please run:
Enable-ExperimentalFeature PSNativeCommandErrorActionPreference
'@
}