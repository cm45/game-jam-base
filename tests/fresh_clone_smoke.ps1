[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GodotPath,
    [string]$Repository,
    [string]$Branch
)

$ErrorActionPreference = "Stop"
$projectRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$temporaryRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$temporaryProject = [System.IO.Path]::GetFullPath(
    (Join-Path $temporaryRoot ("game-jam-foundation-fresh-clone-" + [System.Guid]::NewGuid().ToString("N")))
)

if (-not $temporaryProject.StartsWith($temporaryRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Temporary clone directory must stay inside the system temp directory."
}
if (-not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) {
    throw "Godot executable was not found: $GodotPath"
}
if ([string]::IsNullOrWhiteSpace($Repository)) {
    $Repository = $projectRoot
}
if ([string]::IsNullOrWhiteSpace($Branch)) {
    if (-not (Test-Path -LiteralPath $Repository -PathType Container)) {
        throw "Pass -Branch when cloning a remote repository URL."
    }
    $Branch = (& git -C $Repository branch --show-current).Trim()
}
if ([string]::IsNullOrWhiteSpace($Branch)) {
    throw "A branch name is required for the fresh-clone smoke test."
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
    & git clone --no-local --branch $Branch $Repository $temporaryProject
    if ($LASTEXITCODE -ne 0) {
        throw "Git could not create a fresh clone of '$Repository' on branch '$Branch'."
    }
    & git -C $temporaryProject lfs pull
    if ($LASTEXITCODE -ne 0) {
        throw "Git LFS could not populate the fresh clone."
    }
    & git -C $temporaryProject lfs fsck
    if ($LASTEXITCODE -ne 0) {
        throw "Git LFS reported an invalid asset in the fresh clone."
    }

    $firstAsset = Get-ChildItem -LiteralPath (Join-Path $temporaryProject "assets\\ninja_adventure\\source") -Recurse -File -Filter "*.png" | Select-Object -First 1
    if ($null -eq $firstAsset -or $firstAsset.Length -lt 1024) {
        throw "The fresh clone does not contain a populated Ninja Adventure image."
    }

    Invoke-GodotCheck -Name "fresh-editor" -Arguments @("--headless", "--path", $temporaryProject, "--editor", "--quit")
    Invoke-GodotCheck -Name "fresh-main" -Arguments @("--headless", "--path", $temporaryProject, "--quit-after", "3")

    $changes = (& git -C $temporaryProject status --porcelain)
    if (-not [string]::IsNullOrWhiteSpace($changes)) {
        throw "Opening a fresh clone created tracked changes:`n$changes"
    }
    Write-Output "fresh_clone_smoke: PASS ($Repository @ $Branch)"
}
finally {
    if (Test-Path -LiteralPath $temporaryProject) {
        Remove-Item -LiteralPath $temporaryProject -Recurse -Force
    }
}