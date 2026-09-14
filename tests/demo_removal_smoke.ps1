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
    }
    finally {
        Remove-Item -LiteralPath $logPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stdoutPath -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $stderrPath -Force -ErrorAction SilentlyContinue
    }
}

try {
    New-Item -ItemType Directory -Path $temporaryProject | Out-Null
    $excludedNames = @(".git", ".godot", "demo", "tests")
    Get-ChildItem -LiteralPath $projectRoot -Force |
        Where-Object { $_.Name -notin $excludedNames } |
        ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $temporaryProject -Recurse -Force }

    Invoke-GodotCheck -Name "demo-free-editor" -Arguments @("--headless", "--path", $temporaryProject, "--editor", "--quit")
    Invoke-GodotCheck -Name "demo-free-main" -Arguments @("--headless", "--path", $temporaryProject, "--quit-after", "3")
    Write-Output "demo_removal_smoke: PASS"
}
finally {
    if (Test-Path -LiteralPath $temporaryProject) {
        Remove-Item -LiteralPath $temporaryProject -Recurse -Force
    }
}