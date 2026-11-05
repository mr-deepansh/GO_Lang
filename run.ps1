<#
.SYNOPSIS
    Cross-platform Go Project & Exercise Runner for Windows PowerShell.
.DESCRIPTION
    Authored for Meridian Engineering & Go Mastery.
    Provides automated commands to run, test, benchmark, and analyze Go code.
.EXAMPLE
    .\run.ps1 01_basics\01_basic.go
    .\run.ps1 -Test
    .\run.ps1 -Race 01_basics\01_basic.go
    .\run.ps1 -Bench
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$Target = "01_basics/01_basic.go",

    [switch]$Test,
    [switch]$Race,
    [switch]$Bench,
    [switch]$Tidy,
    [switch]$Vet,
    [switch]$Escape,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# Auto-detect Go binary
$GoCmd = Get-Command "go" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue
if (-not $GoCmd) {
    $fallbackPaths = @(
        "C:\Program Files\Go\bin\go.exe",
        "C:\Go\bin\go.exe",
        "$env:USERPROFILE\go\bin\go.exe"
    )
    foreach ($p in $fallbackPaths) {
        if (Test-Path $p) {
            $GoCmd = $p
            break
        }
    }
}

if (-not $GoCmd) {
    Write-Host " [ERROR] Go compiler not found! Please install Go from https://go.dev/dl/." -ForegroundColor Red
    exit 1
}

function Show-Header {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "           GOLANG ENGINEERING MASTERY RUNNER              " -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Cyan
    $v = & $GoCmd version
    Write-Host " Toolchain : $v" -ForegroundColor DarkGray
    Write-Host " Binary    : $GoCmd" -ForegroundColor DarkGray
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host ""
}

if ($Help) {
    Show-Header
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\run.ps1 [path/to/file.go]     Run a specific Go file"
    Write-Host "  .\run.ps1 -Test                 Run all unit tests"
    Write-Host "  .\run.ps1 -Race [file.go]       Run with data race detector (-race)"
    Write-Host "  .\run.ps1 -Bench                Run micro-benchmarks"
    Write-Host "  .\run.ps1 -Vet                  Run go vet static analyzer"
    Write-Host "  .\run.ps1 -Escape [file.go]     Run compiler escape analysis (-gcflags='-m')"
    Write-Host "  .\run.ps1 -Tidy                 Sync and tidy go.mod dependencies"
    Write-Host "  .\run.ps1 -Help                 Show this help manual"
    Write-Host ""
    exit 0
}

Show-Header

if ($Tidy) {
    Write-Host " [TASK] Running 'go mod tidy'..." -ForegroundColor Green
    & $GoCmd mod tidy
    Write-Host " [DONE] Modules synchronized successfully." -ForegroundColor Green
    exit 0
}

if ($Vet) {
    Write-Host " [TASK] Running 'go vet ./...'..." -ForegroundColor Green
    & $GoCmd vet ./...
    Write-Host " [DONE] Static analysis completed. No issues detected." -ForegroundColor Green
    exit 0
}

if ($Test) {
    Write-Host " [TASK] Running unit tests with coverage..." -ForegroundColor Green
    & $GoCmd test -v -cover ./...
    exit 0
}

if ($Bench) {
    Write-Host " [TASK] Running benchmarks (mem/allocs)..." -ForegroundColor Green
    & $GoCmd test -bench=. -benchmem ./...
    exit 0
}

if ($Escape) {
    Write-Host " [TASK] Running escape analysis for $Target..." -ForegroundColor Green
    & $GoCmd build -gcflags="-m" $Target
    exit 0
}

if ($Race) {
    Write-Host " [TASK] Running $Target with Race Detector enabled..." -ForegroundColor Yellow
    & $GoCmd run -race $Target
    exit 0
}

# Default: Run the target file
if (Test-Path $Target) {
    Write-Host " [RUN] Executing: $Target" -ForegroundColor Green
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    & $GoCmd run $Target
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " [SUCCESS] Execution finished with exit code 0." -ForegroundColor Green
} else {
    Write-Host " [ERROR] Target file '$Target' not found." -ForegroundColor Red
    Write-Host " Check path or run: .\run.ps1 -Help" -ForegroundColor Yellow
    exit 1
}
