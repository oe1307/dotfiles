$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
if ((Get-Location).ProviderPath -like '\\wsl*') {
    Set-Location $env:USERPROFILE
}
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
$buckets = @(
    foreach ($bucket in $packages.buckets) {
        if ($null -eq $bucket) { continue }

        $bucket.PSObject.Properties.Remove('Updated')
        $bucket.PSObject.Properties.Remove('Manifests')

        $bucket
    }
)

$buckets = @($buckets | Sort-Object -Property Name)
$apps = @(
    foreach ($app in $packages.apps) {
        [PSCustomObject][ordered]@{
            Name   = [string]$app.Name
            Source = [string]$app.Source
        }
    }
)

$apps = @($apps | Sort-Object -Property Name)
$output = [ordered]@{
    buckets = $buckets
    apps    = $apps
}
$result = $output | ConvertTo-Json -Depth 100
$result = $result -replace "`r`n", "`n"
$outputPath = Join-Path $PSScriptRoot 'packages.json'
[System.IO.File]::WriteAllText(
    $outputPath,
    $result + "`n",
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Exported: $outputPath"
