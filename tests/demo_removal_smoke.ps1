[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GodotPath
)

$ErrorActionPreference = "Stop"
$projectRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$temporaryRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$temporaryProject = [System.IO.Path]::GetFullPath(
    (Join-Path $temporaryRoot ("game-jam-foundation-demo-free-" + [System.Guid]::NewGuid().ToString("N")))
)

if (-not $temporaryProject.StartsWith($temporaryRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Temporary test directory must stay inside the system temp directory."
}
if (-not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) {
    throw "Godot console executable was not found: $GodotPath"
}

try {
    New-Item -ItemType Directory -Path $temporaryProject | Out-Null
    $excludedNames = @(".git", ".godot", "demo", "tests")
    Get-ChildItem -LiteralPath $projectRoot -Force |
        Where-Object { $_.Name -notin $excludedNames } |
        ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $temporaryProject -Recurse -Force }

    & $GodotPath --headless --path $temporaryProject --editor --quit
    if ($LASTEXITCODE -ne 0) {
        throw "The demo-free project could not load in the Godot editor."
    }
    & $GodotPath --headless --path $temporaryProject --quit-after 3
    if ($LASTEXITCODE -ne 0) {
        throw "The demo-free project could not start its main scene."
    }
    Write-Output "demo_removal_smoke: PASS"
}
finally {
    if (Test-Path -LiteralPath $temporaryProject) {
        Remove-Item -LiteralPath $temporaryProject -Recurse -Force
    }
}
