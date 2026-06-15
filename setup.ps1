New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null
Set-Content -Path $PROFILE -Value ". `"$HOME\dotfiles\config\powershell\profile.ps1`""

# ssh keys
$path = "$HOME\.ssh\key\github.pem"
(Get-Content -Raw $path) -replace "`r`n","`n" | Set-Content -NoNewline $path

# dotfiles
New-Item -ItemType Directory -Force -Path "$HOME\.config" | Out-Null

$baseSource = Join-Path $HOME "dotfiles\config"
$baseDest   = Join-Path $HOME ".config"

Get-ChildItem -LiteralPath $baseSource -Directory | ForEach-Object {
    $name       = $_.Name
    $sourcePath = $_.FullName
    $destPath   = Join-Path $baseDest $name

    if (Test-Path -LiteralPath $destPath) {
        Remove-Item -LiteralPath $destPath -Recurse -Force
    }

    Copy-Item -LiteralPath $sourcePath -Destination $destPath -Recurse -Force
}
