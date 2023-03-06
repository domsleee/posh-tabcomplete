$ErrorActionPreference = "Stop"
if (Test-Path repo) {
    Remove-Item -r -fo repo
}

Write-Output "set up repo"
mkdir repo
Set-Location repo
git init
Write-Output readme > README.md
git add .
git commit -m "init"
1..100 | ForEach-Object {
    git checkout -b feature/branch$_
}

Set-Location ..
hyperfine `
    --warmup 3 `
    -L script ./CompleteBaseline.ps1,./CompletePoshGit.ps1,./CompleteTabComplete.ps1 `
    "pwsh -NoProfile -File {script}" `
    --export-markdown complete.md `
    --export-csv complete.csv

. $PSScriptRoot/../util.ps1
$csv = "complete.csv"
$tabMs = GetMs $csv "CompleteBaseline.ps1" "CompleteTabComplete.ps1";
$poshMs = GetMs $csv "CompleteBaseline.ps1" "CompletePoshGit.ps1";
$summary = GetSummary $poshMs $tabMs
Write-Output $summary >> complete.md
echo $summary
