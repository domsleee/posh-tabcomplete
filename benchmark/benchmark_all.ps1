. $PSScriptRoot/setupErrorHandling.ps1
pwsh -File "$PSScriptRoot/complete/benchmark_complete.ps1"
pwsh -File "$PSScriptRoot/init/benchmark_init.ps1"

$allBenchmarksFile = "$PSScriptRoot/all.md"
Write-Output "All results" > $allBenchmarksFile
Get-Content $PSScriptRoot/complete/complete.md >> $allBenchmarksFile
Get-Content $PSScriptRoot/complete/complete.md >> $allBenchmarksFile
