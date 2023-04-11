# we're destroying $env:PATH here
pwsh -Command {
    param($scriptRoot)
    . $scriptRoot/setupErrorHandling.ps1
    . $scriptRoot/ensureBenchmarkDepsInstalled.ps1
    cargo build --release
    $binaryPath = $(Resolve-Path "$scriptRoot/../target/release")
    Write-Output "binary path $binaryPath"
    $sep = if ($env:OS -eq "Windows_NT") { ';' } else { ':' }
    $env:PATH = "$binaryPath$sep$env:PATH"
    $actualBinaryDirectory = $(Split-Path $(Get-Command posh-tabcomplete).Path)
    if ($actualBinaryDirectory -ne $binaryPath) {
        Write-Error "Mismatch, expected $binaryPath, got $actualBinaryDirectory"
        exit 1
    }
    $allBenchmarksFile = "$scriptRoot/all.md"
    Write-Output "# All results`n" > $allBenchmarksFile

    $fileSize = $(Get-Item $(Get-Command posh-tabcomplete).Path).Length
    Write-Output "file size: $fileSize"
    Write-Output "file size: $fileSize" >> $allBenchmarksFile
    
    
    Write-Output "## Init`n" >> $allBenchmarksFile
    pwsh -File "$scriptRoot/init/benchmark_init.ps1"
    Get-Content $scriptRoot/init/init.md >> $allBenchmarksFile
    
    Write-Output "## Complete`n" >> $allBenchmarksFile
    pwsh -File "$scriptRoot/complete/benchmark_complete.ps1"
    Get-Content $scriptRoot/complete/complete.md >> $allBenchmarksFile

    Write-Output ""
    Get-Content $allBenchmarksFile
} -args $PSScriptRoot
