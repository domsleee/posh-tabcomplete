#!/usr/bin/env pwsh
$ErrorActionPreference = "stop"
$null = New-Module posh-tabcomplete {
    function Get-JoinPattern($executables) {
        "($($executables -join '|'))"
    }
    $EnableProxyFunctionExpansion = $true
    $knownExecutables = ::TABCOMPLETE_NU_COMMANDS:: # @("git", "npm", "cargo") # @(&posh-tabcomplete nu-commands)
    $GitProxyFunctionRegex = '(^|[;`n])(\s*)(?<cmd>' + (Get-JoinPattern $knownExecutables) + ')(?<params>(([^\S\r\n]|[^\S\r\n]`\r?\n)+\S+)*)(([^\S\r\n]|[^\S\r\n]`\r?\n)+\$args)(\s|`\r?\n)*($|[|;`n])'
    # $GitProxyFunctionRegex = "(^|[;`n])(\s*)(?<cmd>$(Get-JoinPattern $knownExecutables))(?<params>(([^\S\r\n]|[^\S\r\n]``\r?\n)+\S+)*)(([^\S\r\n]|[^\S\r\n]``\r?\n)+\`$args)(\s|``\r?\n)*($|[|;`n])"


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
        $null | &posh-tabcomplete complete "$textToComplete"
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
            $functionItems = Get-ChildItem Function:\
            foreach ($item in $functionItems) {
                if ($item.Definition -match $GitProxyFunctionRegex) {
                    $cmdNames += $item.Name
                }
            }
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