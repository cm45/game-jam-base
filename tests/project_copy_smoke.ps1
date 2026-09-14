[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GodotPath,
    [ValidateRange(10, 300)]
    [int]$TimeoutSeconds = 180
)

$ErrorActionPreference = "Stop"
$projectRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$temporaryRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$temporaryProject = [System.IO.Path]::GetFullPath(
    (Join-Path $temporaryRoot ("game-jam-foundation-source-copy-" + [System.Guid]::NewGuid().ToString("N")))
)

if (-not $temporaryProject.StartsWith($temporaryRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Temporary test directory must stay inside the system temp directory."
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
        $process = Start-Process -FilePath $GodotPath -ArgumentList $quotedArguments -PassThru -NoNewWindow -RedirectStandardOutput $stdoutPath -RedirectStandardError $stderrPath
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            Stop-Process -Id $process.Id -Force
            throw "$Name did not finish within $TimeoutSeconds seconds."
        }
        $log = if (Test-Path -LiteralPath $logPath) { Get-Content -Raw -LiteralPath $logPath } else { "" }
        $stdout = if (Test-Path -LiteralPath $stdoutPath) { Get-Content -Raw -LiteralPath $stdoutPath } else { "" }
        $stderr = if (Test-Path -LiteralPath $stderrPath) { Get-Content -Raw -LiteralPath $stderrPath } else { "" }
        if ($process.ExitCode -ne 0) {
            throw "$Name failed with exit code $($process.ExitCode).`n$log`n$stdout`n$stderr"
        }
        if (($log + $stdout + $stderr) -match "SCRIPT ERROR:") {
            throw "$Name reported a script error.`n$log`n$stdout`n$stderr"
        }
    }
    finally {
        Remove-Item -LiteralPath $logPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stdoutPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stderrPath -Force -ErrorAction SilentlyContinue
    }
}

try {
    New-Item -ItemType Directory -Path $temporaryProject | Out-Null
    $excludedNames = @(".git", ".godot", "tests")
    Get-ChildItem -LiteralPath $projectRoot -Force |
        Where-Object { $_.Name -notin $excludedNames } |
        ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $temporaryProject -Recurse -Force }

    Invoke-GodotCheck -Name "source-copy-editor" -Arguments @("--headless", "--path", $temporaryProject, "--editor", "--quit")
    Invoke-GodotCheck -Name "source-copy-main" -Arguments @("--headless", "--path", $temporaryProject, "--quit-after", "3")
    Write-Output "project_copy_smoke: PASS"
}
finally {
    if (Test-Path -LiteralPath $temporaryProject) {
        Remove-Item -LiteralPath $temporaryProject -Recurse -Force
    }
}
