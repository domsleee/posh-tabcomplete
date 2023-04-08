#!/usr/bin/env pwsh
$ErrorActionPreference = "stop"
$null = New-Module tabcomplete {
    function Get-JoinPattern($executables) {
        "($($executables -join '|'))"
    }
    $EnableProxyFunctionExpansion = $true
    $knownExecutables = @(&tabcomplete nu-commands)#"git", "burrito"
    $GitProxyFunctionRegex = "(^|[;`n])(\s*)(?<cmd>$(Get-JoinPattern $knownExecutables))(?<params>(([^\S\r\n]|[^\S\r\n]``\r?\n)+\S+)*)(([^\S\r\n]|[^\S\r\n]``\r?\n)+\`$args)(\s|``\r?\n)*($|[|;`n])"

    function Main {
        $cmdNames = Get-CommandNamesUsingRegex
        # Write-Error $cmdNames
    
        Microsoft.PowerShell.Core\Register-ArgumentCompleter -CommandName $cmdNames -Native -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
            $padLength = $cursorPosition - $commandAst.Extent.StartOffset
            $textToComplete = $commandAst.ToString().PadRight($padLength, ' ').Substring(0, $padLength);
            Invoke-TabComplete $textToComplete
        }
    }
    
    function Invoke-TabComplete($textToComplete) {
        if ($EnableProxyFunctionExpansion) {
            $textToComplete = Expand-GitProxyFunctionForComplete($textToComplete)
        }
        $null | &tabcomplete complete "$textToComplete"
    }

    # Below is for alias expansion
    # Refer to discussions on GitTabExpansion.ps1 in posh-git
    function Expand-GitProxyFunctionForComplete($command) {
        if ($command -notmatch '^(?<command>\S+)([^\S\r\n]|[^\S\r\n]`\r?\n)+(?<args>([^\S\r\n]|[^\S\r\n]`\r?\n|\S)*)$') {
            return $command
        }
        $arguments = $matches['args']
        $commandName = $matches['command']
    
        # Extract definition of git usage
        if (Test-Path -Path Function:\$commandName) {
            $definition = Get-Item -Path Function:\$commandName | Select-Object -ExpandProperty 'Definition'
            if ($definition -match $GitProxyFunctionRegex) {
                # Clean up the command by removing extra delimiting whitespace and backtick preceding newlines
                return (("$($matches['cmd'].TrimStart()) $($matches['params']) $arguments") -replace '`\r?\n', ' ' -replace '\s+', ' ')
            }
        }

        return $command
    }

    function Get-CommandNamesUsingRegex {
        $cmdNames = $knownExecutables
        if ($EnableProxyFunctionExpansion) {
            $cmdNames += Get-ChildItem -Path Function:\ | Where-Object { $_.Definition -match $GitProxyFunctionRegex } | Foreach-Object Name
        }
        return $cmdNames
    }

    Export-ModuleMember -Function @(
        "Invoke-TabComplete",
        "Expand-GitProxyFunctionForComplete",
        "Get-CommandNamesUsingRegex"
    )

    Main
}