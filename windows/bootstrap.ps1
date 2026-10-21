# One-shot setup for a new Windows machine: Git, this repo, then every
# windows\*.ps1 in order. Re-runnable. See windows\README.md.
#
#   irm https://raw.githubusercontent.com/nasrlol/dot/windows/windows/bootstrap.ps1 | iex
param([string]$Dots = "$HOME\dotfiles")
$ErrorActionPreference = 'Stop'
$raw = 'https://raw.githubusercontent.com/nasrlol/dot/windows/windows/bootstrap.ps1'

# Terminals started by a packaged app (MSIX, from the Microsoft Store) keep
# new files under AppData\Roaming private to that app, and their children don't
# report a package identity. So test the effect: does a new file in %APPDATA%
# land in some app's private Packages\...\LocalCache\Roaming? Then step outside
# via Explorer.
$marker = ".bootstrap-probe-$PID"
New-Item -ItemType File "$env:APPDATA\$marker" -Force | Out-Null
$private = Get-Item "$env:LOCALAPPDATA\Packages\*\LocalCache\Roaming\$marker" -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\$marker" -Force
if ($private) {
    $state = "$HOME\.local\state"
    New-Item -ItemType Directory -Force $state | Out-Null
    $self = "$state\bootstrap.ps1"
    if ($PSCommandPath) { Copy-Item $PSCommandPath $self -Force }
    else { Invoke-WebRequest $raw -OutFile $self -UseBasicParsing }
    "@powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File `"$self`" -Dots `"$Dots`"" | Set-Content "$state\bootstrap.cmd" -Encoding ascii
    Start-Process explorer.exe "`"$state\bootstrap.cmd`""
    'This terminal belongs to a packaged app; setup continues in a new window outside it.'
    return
}

function Refresh-Path { $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User') }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    '== git'
    winget install --id Git.Git --exact --silent --accept-package-agreements --accept-source-agreements --location 'C:\Programs\Git'
    Refresh-Path
}

if (Test-Path "$Dots\.git") {
    git -C $Dots fetch -q origin
    git -C $Dots checkout -q windows
    git -C $Dots pull -q --ff-only
} else {
    # LF endings: the same files are used on Linux
    git clone -q -c core.autocrlf=false -b windows https://github.com/nasrlol/dot.git $Dots
}

foreach ($step in 'packages', 'install', 'apps', 'desktop', 'build-4coder') {
    "== $step"
    Refresh-Path
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$Dots\windows\$step.ps1"
}
'== done. Sign out and back in once so the theme and PATH apply everywhere.'
