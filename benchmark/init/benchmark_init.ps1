. $PSScriptRoot/../setupErrorHandling.ps1
. $PSScriptRoot/../util.ps1
Set-Location $PSScriptRoot
hyperfine `
    --warmup 3 `
    --runs 25 `
    -L profile ./../profiles/ProfileBaseline.ps1,./../profiles/ProfilePoshGit.ps1,./../profiles/ProfileTabComplete.ps1 `
    "pwsh -NoProfile -File {profile}" `
    --export-markdown init.md `
    --export-csv init.csv

$csv = "$PSScriptRoot/init.csv"
$poshMs = GetMs $csv "ProfileBaseline.ps1" "ProfilePoshGit.ps1";
$tabMs = GetMs $csv "ProfileBaseline.ps1" "ProfileTabComplete.ps1";
$summary = GetSummary $poshMs $tabMs
Write-Output "`n$summary" >> "$PSScriptRoot/init.md"
Write-Output $summary
