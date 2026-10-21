# Windows counterpart of packages/world: every third-party program lives in
# C:\Programs\<Name>; winget's portable CLI tools in C:\Programs\WinGet.
# Programs found anywhere else are reinstalled into place. Ends with a full
# upgrade. Apps that manage their own location ($selfManaged) stay put.
#
#   powershell -ExecutionPolicy Bypass -File windows\packages.ps1
$Root = 'C:\Programs'
$remove = '--exact', '--silent', '--accept-source-agreements', '--disable-interactivity'
$common = $remove + '--accept-package-agreements'

# id = folder under C:\Programs, exe that proves it's there[, MSI property for
# the install dir, for MSIs that ignore --location]
$apps = [ordered]@{
    'Git.Git'                    = 'Git',        'cmd\git.exe'
    'Neovim.Neovim'              = 'Neovim',     'bin\nvim.exe'
    'Neovide.Neovide'            = 'Neovide',    'neovide.exe',   'INSTALLDIR'
    'Open-Shell.Open-Shell-Menu' = 'Open-Shell', 'StartMenu.exe'
    'Mozilla.Firefox'            = 'Firefox',    'firefox.exe'
    'VideoLAN.VLC'               = 'VLC',        'vlc.exe'
    'RARLab.WinRAR'              = 'WinRAR',     'WinRAR.exe'
}
# Installers that always pick Program Files: use the upstream portable build
# instead (bump the versions here). folder = winget id of the installer, url, exe
$direct = [ordered]@{
    'Alacritty' = 'Alacritty.Alacritty', 'https://github.com/alacritty/alacritty/releases/download/v0.17.0/Alacritty-v0.17.0-portable.exe', 'alacritty.exe'
    'NASM'      = 'NASM.NASM', 'https://www.nasm.us/pub/nasm/releasebuilds/3.02/win64/nasm-3.02-win64.zip', 'nasm.exe'
    'Emacs'     = 'GNU.Emacs', 'https://ftp.gnu.org/gnu/emacs/windows/emacs-31/emacs-31.1-UCRT64.zip', 'bin\runemacs.exe'
    # zip holds one versioned exe; "portable" in the name keeps settings next to it
    'grepWin'     = 'StefansTools.grepWin', 'https://github.com/stefankueng/grepWin/releases/download/2.1.12/grepWin-x64-2.1.12_portable.zip', 'grepWin_portable.exe'
}
$portables = 'junegunn.fzf', 'BurntSushi.ripgrep.MSVC', 'sharkdp.fd', 'ajeetdsouza.zoxide', 'dandavison.delta',
    'JesseDuffield.lazygit', 'direnv.direnv', 'sxyazi.yazi', 'Fastfetch-cli.Fastfetch', 'aristocratos.btop4win',
    'koalaman.shellcheck', 'JohnnyMorganz.StyLua', 'AlDanial.Cloc'
# Installed wherever they choose: Microsoft's own, rustup (~/.cargo), and
# TaskSlinger, which reinstalls itself to AppData\Local\Programs when run from elsewhere
$selfManaged = 'Microsoft.PowerShell', 'Microsoft.PowerToys', 'Microsoft.VisualStudio.2022.BuildTools', 'Rustlang.Rustup',
    'TaskSlinger.TaskSlinger'

function Installed($id) { winget list --id $id --exact --disable-interactivity | Out-String | Select-String -Quiet -SimpleMatch $id }
function Find-In($dir, $exe) {
    # Emacs nests its tree in emacs-<version>\
    Get-Item "$dir\$exe", "$dir\*\$exe" -ErrorAction SilentlyContinue | Select-Object -First 1
}

# --- winget: portable packages under C:\Programs\WinGet ---
$wingetSettings = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
@"
{
    "`$schema": "https://aka.ms/winget-settings.schema.json",
    "telemetry": { "disable": true },
    "installBehavior": { "portablePackageUserRoot": "$("$Root\WinGet".Replace('\', '/'))" },
    "network": { "downloader": "wininet" }
}
"@ | Set-Content -Encoding ascii $wingetSettings

# --- installer-based apps ---
foreach ($id in $apps.Keys) {
    $dir = Join-Path $Root $apps[$id][0]
    if (Find-In $dir $apps[$id][1]) { "ok       $id"; continue }

    # Firefox and WinRAR may predate winget; their own uninstallers handle that case
    $winrarKey = Get-Item "$env:ProgramFiles\WinRAR\rarreg.key" -ErrorAction SilentlyContinue
    if ($id -eq 'Mozilla.Firefox' -and (Test-Path "$env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe")) {
        Start-Process "$env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe" '/S' -Wait
    } elseif (Installed $id) {
        winget uninstall --id $id @remove --force | Out-Null
    }
    $msi = if ($apps[$id].Count -gt 2) { '--custom', "$($apps[$id][2])=`"$dir`"" } else { @() }
    winget install --id $id @common --location $dir @msi | Out-Null
    if ($winrarKey) { Copy-Item $winrarKey.FullName $dir }
    $hit = Find-In $dir $apps[$id][1]
    "{0,-8} {1} -> {2}" -f $(if ($hit) { 'moved' } else { 'FAILED' }), $id, $(if ($hit) { $hit.FullName } else { $dir })
}

# --- upstream portable builds ---
foreach ($name in $direct.Keys) {
    $id, $url, $exe = $direct[$name]
    $dir = Join-Path $Root $name
    if (Find-In $dir $exe) { "ok       $name"; continue }
    if (Installed $id) { winget uninstall --id $id @remove | Out-Null }
    if (Test-Path "$env:ProgramFiles\$name\Uninstall.exe") { Start-Process "$env:ProgramFiles\$name\Uninstall.exe" '/S' -Verb RunAs -Wait }
    $tmp = Join-Path $env:TEMP "portable-$name"
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force $tmp, $dir | Out-Null
    $file = Join-Path $tmp (Split-Path $url -Leaf)
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $url -OutFile $file -UseBasicParsing
    if ($file -like '*.zip') {
        Expand-Archive $file "$tmp\x"
        # flatten a single top-level folder (nasm-3.02\...)
        $top = Get-ChildItem "$tmp\x"
        $src = if ($top.Count -eq 1 -and $top[0].PSIsContainer) { $top[0].FullName } else { "$tmp\x" }
        Copy-Item "$src\*" $dir -Recurse -Force
        # a lone versioned exe (grepWin-x64-2.1.12_portable.exe) gets a stable name
        $exes = Get-ChildItem $dir -Filter *.exe
        if (-not (Find-In $dir $exe) -and $exes.Count -eq 1) { Move-Item $exes[0].FullName (Join-Path $dir $exe) -Force }
    } else {
        Copy-Item $file (Join-Path $dir $exe) -Force
    }
    $hit = Find-In $dir $exe
    "{0,-8} {1} -> {2}" -f $(if ($hit) { 'moved' } else { 'FAILED' }), $name, $(if ($hit) { $hit.FullName } else { $dir })
}

# --- portable CLI tools ---
foreach ($id in $portables) {
    $pkg = Get-Item "$Root\WinGet\$id*" -ErrorAction SilentlyContinue
    if ($pkg) { "ok       $id"; continue }
    if (Installed $id) { winget uninstall --id $id @remove | Out-Null }
    winget install --id $id @common | Out-Null
    "{0,-8} {1}" -f $(if (Get-Item "$Root\WinGet\$id*" -ErrorAction SilentlyContinue) { 'moved' } else { 'FAILED' }), $id
}

# File Pilot installs itself to C:\Programs\FilePilot; drop winget's extra copy
if ((Test-Path "$Root\FilePilot\FPilot.exe") -and (Installed 'Voidstar.FilePilot')) {
    winget uninstall --product-code Voidstar.FilePilot_Microsoft.Winget.Source_8wekyb3d8bbwe @remove | Out-Null
    if ($LASTEXITCODE) { 'FAILED   removing winget copy of File Pilot (close File Pilot and re-run)' }
    else { 'removed  winget copy of File Pilot (kept C:\Programs\FilePilot)' }
}

foreach ($id in $selfManaged) {
    if (Installed $id) { continue }
    $extra = if ($id -like '*BuildTools') { '--override', '--wait --passive --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended' } else { @() }
    winget install --id $id @common @extra | Out-Null
    "installed $id"
}

# --- everything else up to date ---
winget upgrade --all @common --include-unknown | Out-Null
'upgraded all'
