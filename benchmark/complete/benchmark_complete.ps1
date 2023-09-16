
. $PSScriptRoot/../setupErrorHandling.ps1
$childRepoDir = "$PSScriptRoot/repo"
if (Test-Path "$childRepoDir") {
    Remove-Item -r -fo "$childRepoDir"
}

Write-Output "set up childRepoDir"
mkdir "$childRepoDir"
Set-Location "$childRepoDir"
git init
Write-Output readme > README.md
git add .
git commit -m "init"
1..100 | ForEach-Object {
    git checkout -b feature/branch$_
}

Set-Location "$PSScriptRoot"
hyperfine `
    --warmup 3 `
    --runs 75 `
    -L script CompleteBaseline.ps1,CompletePoshGit.ps1,CompleteTabComplete.ps1 `
    "pwsh -NoProfile -File {script}" `
    --export-markdown $PSScriptRoot/complete.md `
    --export-csv $PSScriptRoot/complete.csv

. $PSScriptRoot/../util.ps1
$csv = "$PSScriptRoot/complete.csv"
$tabMs = GetMs $csv "CompleteBaseline.ps1" "CompleteTabComplete.ps1";
$poshMs = GetMs $csv "CompleteBaseline.ps1" "CompletePoshGit.ps1";
$summary = GetSummary $poshMs $tabMs
Write-Output "`n$summary" >> $PSScriptRoot/complete.md
Write-Output $summary
