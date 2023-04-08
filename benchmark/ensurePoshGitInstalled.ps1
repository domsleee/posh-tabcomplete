if (-not (Get-Module posh-git)) {
    Write-Output "posh-git not installed, installing posh-git"
    Write-Output "note: to uninstall, it is 'Uninstall-Module posh-git'"
    Install-Module posh-git -Scope CurrentUser -Force
}