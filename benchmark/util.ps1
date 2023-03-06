function GetMs {
    param ([string] $csv, [string] $baselineFile, [string] $profileFile)
    $baselineEntry = Import-Csv $csv | Where-Object { $_.command.Contains($baselineFile) } | Select-Object -First 1
    $entry = Import-Csv $csv | Where-Object { $_.command.Contains($profileFile) } | Select-Object -First 1
    $seconds = $entry.mean - $baselineEntry.mean
    return [math]::Round([timespan]::fromseconds($seconds).Milliseconds, 2)
}

function GetSummary {
    param ([double] $poshMs, [double] $tabMs)
    return "tabcomplete: ${tabMs}ms, posh-git: ${poshMs}ms ($([math]::Round($poshMs / $tabMs, 2))x faster)"
}