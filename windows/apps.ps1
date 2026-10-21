# Desktop + Start Menu shortcuts for the daily apps, and niri-style global
# hotkeys through PowerToys Keyboard Manager. Re-runnable.
#
#   powershell -ExecutionPolicy Bypass -File windows\apps.ps1
$ErrorActionPreference = 'Stop'
$programs = "$env:LOCALAPPDATA\Programs"

function Find-Exe([string[]]$candidates) {
    foreach ($c in $candidates) { $hit = Get-Item $c -ErrorAction SilentlyContinue | Select-Object -First 1; if ($hit) { return $hit.FullName } }
}

$apps = [ordered]@{
    '4coder'       = Find-Exe "$programs\4coder\4ed.exe"
    'File Pilot'   = Find-Exe "$programs\FilePilot\FPilot.exe", "$programs\File Pilot\*.exe", "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Voidstar.FilePilot*\*.exe", "$env:ProgramFiles\File Pilot\*.exe", "$env:LOCALAPPDATA\Microsoft\WinGet\Links\FPilot.exe"
    'RAD Debugger' = Find-Exe "$programs\raddbg\raddbg.exe"
    'Alacritty'    = Find-Exe "$env:ProgramFiles\Alacritty\alacritty.exe"
    'Emacs'        = Find-Exe "$env:ProgramFiles\Emacs\emacs-*\bin\runemacs.exe"
    'Neovide'      = Find-Exe "$env:ProgramFiles\Neovide\neovide.exe", "$programs\Neovide\neovide.exe"
    'Firefox'      = Find-Exe "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
}

# --- shortcuts ---
$wsh = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
$startMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
foreach ($name in '4coder', 'File Pilot', 'RAD Debugger', 'Alacritty', 'Emacs', 'Neovide') {
    $exe = $apps[$name]
    if (-not $exe) { "skip shortcut: $name not found"; continue }
    foreach ($dir in $desktop, $startMenu) {
        $lnk = $wsh.CreateShortcut("$dir\$name.lnk")
        $lnk.TargetPath = $exe
        $lnk.WorkingDirectory = if ($name -eq 'Alacritty') { $HOME } else { Split-Path $exe }
        $lnk.Save()
    }
    "shortcut: $name -> $exe"
}

# --- PowerToys Keyboard Manager (README "niri (Mod = Super)" table) ---
# Key codes are Windows virtual keys: 91 LWin, 16 Shift, 18 Alt, 13 Enter, 32 Space, 115 F4, 38 Up.
function Run($keys, $exe) {
    [ordered]@{
        originalKeys = $keys; exactMatch = $false; operationType = 1
        runProgramFilePath = $exe; runProgramArgs = ''; runProgramStartInDir = (Split-Path $exe)
        runProgramElevationLevel = 0; runProgramAlreadyRunningAction = 0; runProgramStartWindowType = 0
        newRemapKeys = ''; unicodeText = '*Unsupported*'
    }
}
function Remap($keys, $to) {
    [ordered]@{ originalKeys = $keys; exactMatch = $false; operationType = 0; newRemapKeys = $to; unicodeText = '*Unsupported*' }
}

$binds = @(
    @('91;13', 'Alacritty'),        # Mod+Return    terminal (foot)
    @('91;78', '4coder'),           # Mod+N         4coder
    @('91;69', 'Emacs'),            # Mod+E         emacs
    @('91;66', 'Firefox'),          # Mod+B         firefox
    @('91;16;69', 'File Pilot'),    # Mod+Shift+E   file manager
    @('91;16;68', 'RAD Debugger')   # Mod+Shift+D   debugger
)
$global = @()
foreach ($b in $binds) {
    if ($apps[$b[1]]) { $global += Run $b[0] $apps[$b[1]] } else { "skip bind: $($b[1]) not found" }
}
$global += Remap '91;81' '18;115'   # Mod+Q  close window (Alt+F4)
$global += Remap '91;70' '91;38'    # Mod+F  maximize (Win+Up)
$global += Remap '91;80' '91;18;32' # Mod+P  launcher (Command Palette, Win+Alt+Space)

$kbm = "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager"
New-Item -ItemType Directory -Force $kbm | Out-Null
$config = [ordered]@{
    remapKeys            = @{ inProcess = @() }
    remapKeysToText      = @{ inProcess = @() }
    remapShortcuts       = [ordered]@{ global = $global; appSpecific = @() }
    remapShortcutsToText = [ordered]@{ global = @(); appSpecific = @() }
}
function Write-Json($path, $text) { [IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding $false)) }

# PowerToys keeps its settings open, so stop it while writing
Get-Process PowerToys* -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep 2

Write-Json "$kbm\default.json" ($config | ConvertTo-Json -Depth 6)
if (-not (Test-Path "$kbm\settings.json")) {
    Write-Json "$kbm\settings.json" '{"properties":{"activeConfiguration":{"value":"default"},"keyboardConfigurations":{"value":["default"]}},"name":"Keyboard Manager","version":"1"}'
}
"keyboard manager: $($global.Count) bindings -> $kbm\default.json"

# Turn the module on
$pt = "$env:LOCALAPPDATA\Microsoft\PowerToys\settings.json"
$s = if (Test-Path $pt) { Get-Content $pt -Raw | ConvertFrom-Json }
if ($s.enabled) {
    $s.enabled | Add-Member -Force NoteProperty 'Keyboard Manager' $true
    Write-Json $pt ($s | ConvertTo-Json -Depth 10 -Compress)
} else { "PowerToys settings not found: enable Keyboard Manager in PowerToys Settings" }
$exe = Find-Exe "$env:LOCALAPPDATA\PowerToys\PowerToys.exe", "$programs\PowerToys\PowerToys.exe", "$env:ProgramFiles\PowerToys\PowerToys.exe"
if ($exe) { Start-Process $exe; "restarted PowerToys" }
