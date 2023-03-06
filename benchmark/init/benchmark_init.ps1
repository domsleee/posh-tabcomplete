$ErrorActionPreference = "Stop"
. $PSScriptRoot/../util.ps1
hyperfine `
    --warmup 3 `
    -L profile ../profiles/ProfileBaseline.ps1,../profiles/ProfilePoshGit.ps1,../profiles/ProfileTabComplete.ps1 `
    "pwsh -NoProfile -File {profile}" `
    --export-markdown init.md `
    --export-csv init.csv

$csv = "init.csv"
$poshMs = GetMs $csv "ProfileBaseline.ps1" "ProfilePoshGit.ps1";
$tabMs = GetMs $csv "ProfileBaseline.ps1" "ProfileTabComplete.ps1";
$summary = GetSummary $poshMs $tabMs
Write-Output $summary >> init.md
echo $summary
