
$ErrorActionPreference = 'Stop'

# UTF-8（BOMなし）
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

# WSL経由でWindows PowerShellを起動した場合の対策
if ((Get-Location).ProviderPath -like '\\wsl*') {
    Set-Location $env:USERPROFILE
}

# scoop export
try {
    $global:LASTEXITCODE = 0

    $json = & scoop export | Out-String

    if ($LASTEXITCODE -ne 0) {
        throw "終了コード: $LASTEXITCODE"
    }

    $packages = $json.TrimStart([char]0xFEFF) | ConvertFrom-Json
}
catch {
    Write-Error "scoop export に失敗しました。`n$_"
    exit 1
}

# buckets: 不要なプロパティを削除して名前順にソート
$buckets = @(
    foreach ($bucket in $packages.buckets) {
        if ($null -eq $bucket) { continue }

        $bucket.PSObject.Properties.Remove('Updated')
        $bucket.PSObject.Properties.Remove('Manifests')

        $bucket
    }
)

$buckets = @($buckets | Sort-Object -Property Name)

# apps: NameとSourceだけを残して名前順にソート
$apps = @(
    foreach ($app in $packages.apps) {
        [PSCustomObject][ordered]@{
            Name   = [string]$app.Name
            Source = [string]$app.Source
        }
    }
)

$apps = @($apps | Sort-Object -Property Name)

# 出力データ
$output = [ordered]@{
    buckets = $buckets
    apps    = $apps
}

# JSONに変換
$result = $output | ConvertTo-Json -Depth 100

# 改行コードをLFに統一
$result = $result -replace "`r`n", "`n"

# スクリプトと同じディレクトリに保存
$outputPath = Join-Path $PSScriptRoot 'packages.json'

# UTF-8 BOMなし、末尾改行あり
[System.IO.File]::WriteAllText(
    $outputPath,
    $result + "`n",
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Exported: $outputPath"
