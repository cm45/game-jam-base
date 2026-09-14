[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GodotPath,
    [switch]$SkipFreshClone,
    [switch]$SkipExport
)

$ErrorActionPreference = "Stop"
$projectRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$temporaryRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$exportDirectory = [System.IO.Path]::GetFullPath((Join-Path $projectRoot "build\\release-readiness"))

if (-not $exportDirectory.StartsWith($projectRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Release export output must stay inside the project build directory."
}
if (-not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) {
    throw "Godot executable was not found: $GodotPath"
}

function Invoke-GodotCheck {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $logStem = "game-jam-foundation-" + $Name + "-" + [System.Guid]::NewGuid().ToString("N")
    $logPath = Join-Path $temporaryRoot ($logStem + ".log")
    $stdoutPath = Join-Path $temporaryRoot ($logStem + ".stdout")
    $stderrPath = Join-Path $temporaryRoot ($logStem + ".stderr")
    $quotedArguments = (($Arguments + @("--log-file", $logPath)) | ForEach-Object { '"' + $_.Replace('"', '\"') + '"' }) -join " "
    try {
        $process = Start-Process -FilePath $GodotPath -ArgumentList $quotedArguments -Wait -PassThru -NoNewWindow -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
        $log = if (Test-Path -LiteralPath $logPath) { Get-Content -Raw -LiteralPath $logPath } else { "" }
        if ($process.ExitCode -ne 0) {
            throw "$Name failed with exit code $($process.ExitCode).`n$log"
        }
        return $log
    }
    finally {
        Remove-Item -LiteralPath $logPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stdoutPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stderrPath -Force -ErrorAction SilentlyContinue
    }
}

function Assert-PassMarker {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Log,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($Log -notmatch [regex]::Escape("${Name}: PASS")) {
        throw "$Name ended without its PASS marker."
    }
}

$null = Invoke-GodotCheck -Name "editor-import" -Arguments @("--headless", "--path", $projectRoot, "--editor", "--quit")
Write-Output "editor_import: PASS"
$null = Invoke-GodotCheck -Name "main-startup" -Arguments @("--headless", "--path", $projectRoot, "--quit-after", "3")
Write-Output "main_startup: PASS"

$sceneTests = @(
    @{ Name = "progression_layout_smoke"; Scene = "res://tests/progression_layout_smoke.tscn" },
    @{ Name = "save_reset_smoke"; Scene = "res://tests/save_reset_smoke.tscn" },
    @{ Name = "run_contract_smoke"; Scene = "res://tests/run_contract_smoke.tscn" },
    @{ Name = "demo_loop_smoke"; Scene = "res://tests/demo_loop_smoke.tscn" }
)
foreach ($test in $sceneTests) {
    $log = Invoke-GodotCheck -Name $test.Name -Arguments @("--headless", "--path", $projectRoot, "--scene", $test.Scene)
    Assert-PassMarker -Log $log -Name $test.Name
    Write-Output ("{0}: PASS" -f $test.Name)
}

& (Join-Path $PSScriptRoot "demo_removal_smoke.ps1") -GodotPath $GodotPath

if (-not $SkipFreshClone) {
    & (Join-Path $PSScriptRoot "fresh_clone_smoke.ps1") -GodotPath $GodotPath -Repository $projectRoot
}

if (-not $SkipExport) {
    try {
        New-Item -ItemType Directory -Path $exportDirectory -Force | Out-Null
        $exportPath = Join-Path $exportDirectory "GameJamFoundation.exe"
        $null = Invoke-GodotCheck -Name "windows-export" -Arguments @("--headless", "--path", $projectRoot, "--export-release", "Windows Desktop", $exportPath)
        if (-not (Test-Path -LiteralPath $exportPath -PathType Leaf)) {
            throw "Godot reported a successful Windows export but did not create $exportPath."
        }
        $exportProcess = Start-Process -FilePath $exportPath -ArgumentList '"--headless" "--quit-after" "3"' -Wait -PassThru -NoNewWindow
        if ($exportProcess.ExitCode -ne 0) {
            throw "The exported Windows build exited with code $($exportProcess.ExitCode)."
        }
        Write-Output "windows_export_smoke: PASS"
    }
    finally {
        if (Test-Path -LiteralPath $exportDirectory) {
            Remove-Item -LiteralPath $exportDirectory -Recurse -Force
        }
    }
}

Write-Output "release_validation: PASS"
