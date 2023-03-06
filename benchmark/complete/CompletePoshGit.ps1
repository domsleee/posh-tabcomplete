$ErrorActionPreference = "Stop"
. $PSScriptRoot/../profiles/BothProfiles.ps1
cd repo
$len = $(Expand-GitCommand "git checkout ")
if ($len.Length -lt 50) { exit 1; }