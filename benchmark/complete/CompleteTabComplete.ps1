$ErrorActionPreference = "Stop"
. $PSScriptRoot/../profiles/BothProfiles.ps1
cd repo
$len = $(Invoke-TabComplete "git checkout ")
echo $len.Length
if ($len.Length -lt 50) { exit 1; }