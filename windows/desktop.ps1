# Desktop look from the niri setup: theme/palette-dark colors, the niri
# background and focus ring, the Bibata cursor, and an empty taskbar.
# Per-user (HKCU) only. Re-runnable.
#
#   powershell -ExecutionPolicy Bypass -File windows\desktop.ps1
$ErrorActionPreference = 'Stop'
$dots = Split-Path $PSScriptRoot

# Colors straight from theme/palette-dark
$palette = @{}
Get-Content "$dots\theme\palette-dark" | Where-Object { $_ -match '^([a-z_]+)=#([0-9a-fA-F]{6})$' } | ForEach-Object { $palette[$Matches[1]] = $Matches[2] }
function Rgb($hex) { [Convert]::ToInt32($hex.Substring(0, 2), 16), [Convert]::ToInt32($hex.Substring(2, 2), 16), [Convert]::ToInt32($hex.Substring(4, 2), 16) }
function Abgr($hex) { $r, $g, $b = Rgb $hex; [BitConverter]::ToInt32([byte[]]($r, $g, $b, 0xFF), 0) }
function Argb($hex, $alpha) { $r, $g, $b = Rgb $hex; [BitConverter]::ToInt32([byte[]]($b, $g, $r, $alpha), 0) }

$focus      = $palette.rust      # niri focus-ring active-color
$background = $palette.bg_alt    # niri layout background-color

# --- dark mode, flat ---
$personalize = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
Set-ItemProperty $personalize AppsUseLightTheme 0
Set-ItemProperty $personalize SystemUsesLightTheme 0
Set-ItemProperty $personalize EnableTransparency 0
Set-ItemProperty $personalize ColorPrevalence 0          # taskbar/start stay dark, like waybar

# --- accent = focus ring, on title bars and window borders ---
$dwm = 'HKCU:\Software\Microsoft\Windows\DWM'
Set-ItemProperty $dwm AccentColor (Abgr $focus) -Type DWord
Set-ItemProperty $dwm ColorizationColor (Argb $focus 0xC4) -Type DWord
Set-ItemProperty $dwm ColorizationAfterglow (Argb $focus 0xC4) -Type DWord
Set-ItemProperty $dwm ColorPrevalence 1 -Type DWord
Set-ItemProperty $dwm EnableWindowColorization 1 -Type DWord
$accent = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent'
if (-not (Test-Path $accent)) { New-Item $accent -Force | Out-Null }
# AccentPalette: 8 RGBA swatches from light to dark; Windows picks shades from it
$shades = $palette.accent_bright, $palette.accent, $palette.rust_bright, $focus, $palette.cursor_alt, $palette.border, $palette.surface, $palette.bg
$bytes = foreach ($s in $shades) { (Rgb $s) + 0 }
Set-ItemProperty $accent AccentPalette ([byte[]]$bytes) -Type Binary
Set-ItemProperty $accent AccentColorMenu (Abgr $focus) -Type DWord
Set-ItemProperty $accent StartColorMenu (Abgr $palette.surface) -Type DWord
Set-ItemProperty 'HKCU:\Control Panel\Desktop' AutoColorization 0

# --- solid niri background instead of a wallpaper ---
$r, $g, $b = Rgb $background
Set-ItemProperty 'HKCU:\Control Panel\Colors' Background "$r $g $b"
Set-ItemProperty 'HKCU:\Control Panel\Desktop' WallPaper ''

# --- cursor: Bibata Original Ice (niri xcursor-theme) ---
$cursors = "$env:LOCALAPPDATA\Microsoft\Windows\Cursors\Bibata-Original-Ice"
if (-not (Test-Path "$cursors\Pointer.cur")) {
    $zip = "$env:TEMP\bibata.zip"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Original-Ice-Windows.zip -OutFile $zip -UseBasicParsing
    Expand-Archive $zip "$env:TEMP\bibata" -Force
    New-Item -ItemType Directory -Force $cursors | Out-Null
    Copy-Item "$env:TEMP\bibata\Bibata-Original-Ice-Regular-Windows\*" $cursors -Exclude *.inf -Force
}
$map = [ordered]@{
    Arrow = 'Pointer.cur'; Help = 'Help.cur'; AppStarting = 'Work.ani'; Wait = 'Busy.ani'; Crosshair = 'Cross.cur'
    IBeam = 'Text.cur'; NWPen = 'Handwriting.cur'; No = 'Unavailable.cur'; SizeNS = 'Vert.cur'; SizeWE = 'Horz.cur'
    SizeNWSE = 'Dgn1.cur'; SizeNESW = 'Dgn2.cur'; SizeAll = 'Move.cur'; UpArrow = 'Alternate.cur'; Hand = 'Link.cur'
    Pin = 'Pin.cur'; Person = 'Person.cur'
}
$cur = 'HKCU:\Control Panel\Cursors'
Set-ItemProperty $cur '(default)' 'Bibata-Original-Ice'
foreach ($k in $map.Keys) { Set-ItemProperty $cur $k "$cursors\$($map[$k])" -Type ExpandString }
$scheme = ($map.Values | ForEach-Object { "$cursors\$_" }) -join ','
if (-not (Test-Path "$cur\Schemes")) { New-Item "$cur\Schemes" | Out-Null }
Set-ItemProperty "$cur\Schemes" 'Bibata-Original-Ice' $scheme -Type ExpandString

# --- empty taskbar: unpin everything (shortcuts kept in a backup folder) ---
$pins = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
$backup = "$HOME\.local\state\taskbar-pins"
$links = Get-ChildItem $pins -Filter *.lnk -ErrorAction SilentlyContinue
if ($links) {
    New-Item -ItemType Directory -Force $backup | Out-Null
    $links | Move-Item -Destination $backup -Force
    "unpinned: $(($links | ForEach-Object BaseName) -join ', ') (backup: $backup)"
}
Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband' -Recurse -ErrorAction SilentlyContinue

# --- apply: colors, cursor, background, then restart explorer for the taskbar ---
Add-Type -Namespace Win32 -Name Ui -MemberDefinition @'
[DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern bool SystemParametersInfo(uint a, uint b, string c, uint d);
[DllImport("user32.dll")] public static extern bool SetSysColors(int n, int[] e, int[] v);
'@
[Win32.Ui]::SetSysColors(1, @(1), @($r + ($g -shl 8) + ($b -shl 16))) | Out-Null   # COLOR_DESKTOP
[Win32.Ui]::SystemParametersInfo(0x0014, 0, '', 3) | Out-Null                    # SPI_SETDESKWALLPAPER
[Win32.Ui]::SystemParametersInfo(0x0057, 0, $null, 3) | Out-Null                 # SPI_SETCURSORS
Stop-Process -Name explorer -Force
"theme: dark, accent #$focus, background #$background, cursor Bibata-Original-Ice"
