$ErrorActionPreference = 'Stop'

# Use UTF-8 without a BOM for console output and JSON files.
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom

try {
    # Always run the Windows installation of Scoop from the Windows home.
    Get-Command scoop -ErrorAction Stop | Out-Null
    Push-Location -LiteralPath $env:USERPROFILE
    try {
        $global:LASTEXITCODE = 0
        $jsonText = (& scoop export | Out-String)
        if ($LASTEXITCODE -ne 0) {
            throw "scoop export returned exit code $LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }

    if ([string]::IsNullOrWhiteSpace($jsonText)) {
        throw 'scoop export returned no JSON.'
    }

    $packages = $jsonText.TrimStart([char]0xFEFF) | ConvertFrom-Json

    $buckets = @(
        foreach ($bucket in @($packages.buckets)) {
            if ($null -eq $bucket) { continue }
            $bucket.PSObject.Properties.Remove('Updated')
            $bucket.PSObject.Properties.Remove('Manifests')
            $bucket
        }
    )
    $buckets = @($buckets | Sort-Object -Property Name)

    $apps = @(
        foreach ($app in @($packages.apps)) {
            if ($null -eq $app) { continue }
            [PSCustomObject][ordered]@{
                Name   = [string]$app.Name
                Source = [string]$app.Source
            }
        }
    )
    $apps = @($apps | Sort-Object -Property Name)

    $output = [PSCustomObject][ordered]@{
        buckets = $buckets
        apps    = $apps
    }

    $result = $output | ConvertTo-Json -Depth 100
    $result = $result -replace "`r`n", "`n"

    # The location is the same when launched from PowerShell or WSL.
    $outputPath = Join-Path -Path $PSScriptRoot -ChildPath 'packages.json'
    [System.IO.File]::WriteAllText($outputPath, ($result + "`n"), $utf8NoBom)

    Write-Host "Exported: $outputPath"
}
catch {
    [Console]::Error.WriteLine("Export failed: $($_.Exception.Message)")
    exit 1
}
