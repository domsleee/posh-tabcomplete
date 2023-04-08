if (-not (Get-Module posh-git -ListAvailable)) {
    Write-Output "posh-git not installed, installing posh-git"
    Write-Output "to uninstall, use 'Uninstall-Module posh-git'"
    Install-Module posh-git -Scope CurrentUser -Force
}

if (-not (Get-Command hyperfine -ErrorAction SilentlyContinue)) {
  Write-Output "hyperfine not installed, installing hyperfine"
  Write-Output "to unisntall, use 'cargo uninstall hyperfine'"
  cargo install hyperfine
}