New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null
Set-Content -Path $PROFILE -Value ". `"$HOME\dotfiles\config\powershell\profile.ps1`""

# dotfiles
New-Item -ItemType Directory -Force -Path "$HOME\.config" | Out-Null

$linkPath   = Join-Path $HOME ".config\git"
$targetPath = Join-Path $HOME "dotfiles\config\git"
if (Test-Path -LiteralPath $linkPath) {
  Remove-Item -LiteralPath $linkPath -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null

$linkPath   = Join-Path $HOME ".config\nvim"
$targetPath = Join-Path $HOME "dotfiles\config\nvim"
if (Test-Path -LiteralPath $linkPath) {
  Remove-Item -LiteralPath $linkPath -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
