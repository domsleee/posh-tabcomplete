$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# Check if the PowerShell version is 7.4 or higher
if ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -ge 4) {
    Write-Host "PSNativeCommandErrorActionPreference is mainstream in 7.4"
    exit
}

if ($(Get-ExperimentalFeature "PSNativeCommandErrorActionPreference").Enabled -ne $true) {
    Write-Error @'
PSNativeCommandErrorActionPreference (pwsh 7.3 feature) must be enabled to run this script, so that if git.exe fails, the script will STOP
refer to https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3
Please run:
Enable-ExperimentalFeature PSNativeCommandErrorActionPreference
'@
}