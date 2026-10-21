# PowerShell port of fish/.config/fish (config.fish, conf.d/*, functions/*).
# Dot-sourced from $PROFILE by windows/install.ps1. Works in pwsh 7 and 5.1.

# --- env (conf.d/00-env.fish) ---
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$env:LANG = 'en_US.UTF-8'
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = "$HOME\.config" }
$localBin = "$HOME\.local\bin"
if (($env:PATH -split ';') -notcontains $localBin) { $env:PATH = "$localBin;$env:PATH" }
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# fzf theme (conf.d/colors.fish)
$env:FZF_DEFAULT_OPTS = '--height=40% --layout=reverse --border=none --info=inline-right ' +
    '--color=fg:#c4a882,bg:-1,hl:#d48b30,fg+:#d9c6a5,bg+:#1f1610,hl+:#f0a030 ' +
    '--color=info:#8b7355,prompt:#c84820,pointer:#c84820,marker:#d48b30,spinner:#8b7355,header:#6b5a45,gutter:-1'
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'

# --- aliases (config.fish) ---
Set-Alias vim nvim
function ll { Get-ChildItem -Force @args }
function build { & ./build.sh @args }
function bl { & ./build.sh *> log.txt }
function dots { Set-Location "$HOME\dotfiles" }
Set-Item 'function:...' { Set-Location ../.. }
Set-Item 'function:....' { Set-Location ../../.. }

# fish abbreviations -> functions. gc/gl/gp shadow built-in aliases, so drop those first.
foreach ($a in 'gc', 'gl', 'gp') { Remove-Item "alias:$a" -Force -ErrorAction SilentlyContinue }
function g   { git @args }
function gs  { git status -sb @args }
function gd  { git diff @args }
function gds { git diff --staged @args }
function ga  { git add -p @args }
function gc  { git commit @args }
function gl  { git lg @args }
function gp  { git push @args }

# --- functions/ ---
function checkpoint {
    if ($args.Count -eq 0) { Write-Error 'usage: checkpoint <commit message>'; return }
    git add -p
    if ($LASTEXITCODE) { return }
    git diff --cached --quiet
    if (-not $LASTEXITCODE) { Write-Error 'checkpoint: nothing staged'; return }
    git commit -m "$args"
}

function memory {
    param([Parameter(Mandatory)][string]$Target)
    $p = if ($Target -match '^\d+$') { Get-Process -Id $Target -ErrorAction SilentlyContinue }
         else { Get-Process -Name $Target -ErrorAction SilentlyContinue | Sort-Object StartTime | Select-Object -Last 1 }
    if (-not $p) { Write-Error "memory: no process $Target"; return }
    while (-not $p.HasExited) {
        $p.Refresh()
        '{0}  RSS {1:N0} kB  Virt {2:N0} kB  Peak {3:N0} kB' -f $p.Id, ($p.WorkingSet64 / 1kb), ($p.VirtualMemorySize64 / 1kb), ($p.PeakWorkingSet64 / 1kb)
        Start-Sleep 1
    }
}

# MSVC (cl, link) for this shell, like the "x64 Native Tools" prompt
function vcvars {
    $installer = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer"
    if (($env:PATH -split ';') -notcontains $installer) { $env:PATH += ";$installer" }  # VsDevCmd calls vswhere
    $vs = vswhere -latest -products * -property installationPath
    Import-Module "$vs\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64' | Out-Null
}

# --- prompt: "user path $ " ---
function prompt { "$env:USERNAME $($PWD.Path.Replace($HOME, '~')) $ " }

# --- line editing: vi mode + fish-like bindings ---
if (Get-Module -ListAvailable PSReadLine) {
    Set-PSReadLineOption -EditMode Vi -BellStyle None
    Set-PSReadLineOption -Colors @{
        Command = '#d48b30'; Keyword = '#d48b30'; String = '#b86030'; Operator = '#d4a030'
        Variable = '#c4a882'; Parameter = '#b87040'; Comment = '#6b5a45'; Number = '#9b7040'
        Type = '#b87040'; Member = '#c4a882'; Default = '#c4a882'; Error = '#dc4a20'
    }
    # Inline suggestions need PSReadLine 2.1+ (pwsh 7; 5.1 ships 2.0)
    if ((Get-Module PSReadLine).Version -ge [version]'2.1') {
        # fails when output is redirected (scripts, CI); fine to skip there
        try { Set-PSReadLineOption -PredictionSource History -Colors @{ InlinePrediction = '#5a4a38' } -ErrorAction Stop } catch {}
        Set-PSReadLineKeyHandler -Chord Ctrl+f -ViMode Insert -Function AcceptSuggestion
    }
    Set-PSReadLineKeyHandler -Chord Ctrl+e -ViMode Insert -Function ViEditVisually
    Set-PSReadLineKeyHandler -Chord Ctrl+e -ViMode Command -Function ViEditVisually

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        # Ctrl-T: insert a file, Alt-C: cd into a dir, Ctrl-R: history (like `fzf --fish`)
        Set-PSReadLineKeyHandler -Chord Ctrl+t -ViMode Insert -ScriptBlock {
            $f = fd --type f --hidden --exclude .git | fzf
            if ($f) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert($f) }
        }
        Set-PSReadLineKeyHandler -Chord Alt+c -ViMode Insert -ScriptBlock {
            $d = fd --type d --hidden --exclude .git | fzf
            if ($d) {
                Set-Location $d
                [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
            }
        }
        Set-PSReadLineKeyHandler -Chord Ctrl+r -ViMode Insert -ScriptBlock {
            $hist = (Get-PSReadLineOption).HistorySavePath
            if (-not (Test-Path $hist)) { return }
            $line = $null; $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            $pick = Get-Content $hist | Select-Object -Unique | ForEach-Object { $_ } |
                Sort-Object { $i++ } -Descending | fzf --no-sort --query "$line"
            if ($pick) {
                [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($pick)
            }
        }
    }
}

# --- tools (conf.d/tools.fish) ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Per-machine overrides (like local.fish), not committed
$localProfile = Join-Path $PSScriptRoot 'local.ps1'
if (Test-Path $localProfile) { . $localProfile }
