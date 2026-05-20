New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null
Set-Content -Path $PROFILE -Value ". `"$HOME\dotfiles\config\powershell\profile.ps1`""

# ssh keys
$path = "$HOME\.ssh\key\github.pem"
(Get-Content -Raw $path) -replace "`r`n","`n" | Set-Content -NoNewline $path

# dotfiles
New-Item -ItemType Directory -Force -Path "$HOME\.config" | Out-Null
$baseTarget = Join-Path $HOME "dotfiles\config"
$baseLink   = Join-Path $HOME ".config"
Get-ChildItem -LiteralPath $baseTarget -Directory | ForEach-Object {
    $name       = $_.Name
    $targetPath = $_.FullName
    $linkPath   = Join-Path $baseLink $name
    if (Test-Path -LiteralPath $linkPath) {
        Remove-Item -LiteralPath $linkPath -Recurse -Force
    }
    New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
}
