# Windows

The Linux setup (niri + fish + nvim/emacs, one amber palette) carried over to
Windows 10/11 as far as it goes. First built on DESKTOP-424414S (Windows 10 Home
19045), October 2026.

## Quick start (new machine)

```powershell
# once, in a normal (not packaged-app) PowerShell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
irm https://raw.githubusercontent.com/nasrlol/dot/windows/windows/bootstrap.ps1 | iex
```

`bootstrap.ps1` installs Git if missing, clones this repo to `~/dotfiles`
(branch `windows`), then runs, in order:

| Script | What it does | Admin |
|---|---|---|
| `packages.ps1` | installs/moves every program into `C:\Programs`, then `winget upgrade --all` | UAC prompts per app |
| `install.ps1` | links configs (like `stow`), env vars, PATH, fonts, ssh/git shims, PowerShell profile | no |
| `apps.ps1` | Start Menu shortcuts, PowerToys hotkeys, Open-Shell look | no |
| `desktop.ps1` | niri theme, Bibata cursor, empty taskbar | no |
| `build-4coder.ps1` | builds 4coder (upstream core + the byp layer) into `C:\Programs\4coder` | no |

Every script is re-runnable. Afterwards: sign out and back in once (theme, PATH).

## Layout

| Where | What |
|---|---|
| `C:\Programs\<Name>` | every third-party program |
| `C:\Programs\WinGet` | winget's portable CLI tools (`installBehavior.portablePackageUserRoot`) |
| `~/dotfiles` | this repo; configs are junctions into it |
| `~/src/4coder`, `~/src/4cc` | 4coder layer (nasrlol/4coder) and upstream core (4coder-community/4cc) |
| `~/.config` | `XDG_CONFIG_HOME`; nvim, git, lazygit read it like on Linux |
| `~/.local/bin`, `~/.local/state` | own scripts; state (taskbar pin backup, logs) |
| Program Files / AppData | only what manages its own location: PowerShell 7, PowerToys, VS Build Tools, rustup, TaskSlinger |

## Programs

| Program | Source | Notes |
|---|---|---|
| 4coder | built from 4cc `develop` + byp layer | layer is compiled against the core's API tables (`build-4coder.ps1`) |
| File Pilot | winget, self-installs to `C:\Programs\FilePilot` | |
| RAD Debugger | GitHub release zip | `C:\Programs\raddbg` |
| TaskSlinger | winget | self-managed in `AppData\Local\Programs`; reinstalls itself there if moved |
| grepWin | GitHub portable zip | kept as `grepWin_portable.exe` so settings stay in `grepwin.ini` |
| Neovim, Neovide | winget (Neovide MSI via `INSTALLDIR`) | |
| Emacs, Alacritty, NASM | upstream portable builds | their installers ignore any install dir |
| Git (+ `usr\bin` for less/grep) | winget | |
| fzf rg fd zoxide delta lazygit yazi btop fastfetch direnv shellcheck stylua cloc | winget portables | |
| Firefox, VLC, WinRAR | winget | WinRAR's `rarreg.key` is carried over on move |
| Open-Shell | winget | replaces the Start menu |
| PowerShell 7, PowerToys, VS 2022 Build Tools (C++), rustup | winget | default locations |

Versions installed at the time: Neovim 0.12.6, Emacs 31.1, Git 2.55, PowerShell
7.6.7, lazygit 0.66.1, ripgrep 15.2, fzf 0.74.5, NASM 3.02, Neovide 0.16.2,
Alacritty 0.17.0, 4cc core `c0ba582` (2026-07-09).

## Configs

| Linux | Windows |
|---|---|
| `nvim/` | `~/.config/nvim` (junction); plugins via `vim.pack` on first start |
| `emacs/` | `%APPDATA%\.emacs.d` (junction); packages via use-package on first start |
| `git/` | `~/.config/git`; `git/.config/git/local` (untracked) turns signing off until `~/.ssh/id_ed25519` exists |
| `lazygit/`, `neovide/` | `~/.config/...` and `%APPDATA%\...` junctions |
| `alacritty/` | `%APPDATA%\alacritty\alacritty.toml` imports the repo file, adds pwsh + font size 11 |
| `ssh/` | `~/.ssh/config` without ControlMaster (Windows OpenSSH lacks it) |
| `fish/` | `windows/profile.ps1`: aliases, git abbrs, vi mode, fzf Ctrl-T/Alt-C/Ctrl-R, zoxide, palette colors, `vcvars` for MSVC |
| `theme/palette-dark` | `desktop.ps1` reads it directly |

Not ported (no Windows equivalent): niri, waybar, foot, wofi, tmux, fish,
suckless, greetd, `system/`, Gentoo package list.

## Desktop

- **Theme:** dark mode, no transparency, accent = niri focus ring `#c84820` on
  title bars/borders, solid desktop `#1a1208`, Bibata Original Ice cursor.
- **Taskbar:** nothing pinned (old pins backed up to `~/.local/state/taskbar-pins`);
  Open-Shell paints it `#111111` with `#c4a882` text, like waybar.
- **Start menu:** Open-Shell, Immersive dark skin, inline program list,
  flat Windows 10 button. Shift+Win opens the stock menu.
- **Desktop:** empty; shortcuts live in the Start Menu only.
- **PowerToys:** Keyboard Manager on, tray icon hidden, Command Palette on Win+Alt+Space.

## Hotkeys (niri `Mod` = Win)

| Keys | Action |
|---|---|
| Win+Enter | Alacritty |
| Win+P | launcher (Command Palette) |
| Win+N | 4coder |
| Win+E | Emacs |
| Win+B | Firefox |
| Win+Shift+E | File Pilot |
| Win+Shift+D | RAD Debugger |
| Win+F | maximize |
| Win+Q | close window |

## Fixes worth knowing

- **Terminals inside packaged (MSIX/Store) apps:** new files under
  `AppData\Roaming` land in that app's private copy; nothing else sees them.
  `bootstrap.ps1` detects this and relaunches itself through Explorer.
- **Hotkey-launched apps inherit PowerToys' environment**, so `apps.ps1` starts
  PowerToys and Open-Shell through Explorer to pick up PATH changes.
- **nvim E1568 / stray `+q4D73` in Alacritty:** Windows 10's ConPTY garbles
  terminal replies; `packages.ps1` puts Microsoft's newer `conpty.dll` +
  `OpenConsole.exe` next to `alacritty.exe`.
- **winget downloads from GNU/VideoLAN mirrors fail** with Delivery
  Optimization; winget uses `wininet` instead.

## Left to do by hand

Admin PowerShell, optional:

```powershell
# services this hardware doesn't need (no printer, NFC); undo: -StartupType Manual
foreach ($s in 'Spooler','PrintNotify','MapsBroker','TrkWks','SEMgrSvc') { Set-Service $s -StartupType Disabled; Stop-Service $s -Force -ErrorAction SilentlyContinue }
```

- Startup apps (Discord, Epic, Firefox) were turned off per machine in Task Manager → Startup.
- Add `~/.ssh/id_ed25519`, then delete `git/.config/git/local` to sign commits again.
