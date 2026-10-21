# dotfiles

niri + waybar + foot + fish, nvim and emacs, on Gentoo (Apple Silicon
MacBook, Asahi) and Void (san-giminiano: MSI laptop board, Intel UHD 630 +
GTX 1050, used as a desktop on a 1080p monitor). One warm amber palette across
everything.

## Install

```sh
git clone git@github.com:nasrlol/dot ~/dotfiles
cd ~/dotfiles
./install --host asahi            # link packages with GNU Stow
./install --system                # + system/<host>/ files into / (sudo)
./install --services              # + runit services from system/<host>.services (sudo)
./install --packages              # + packages/world (emerge) or packages/void (xbps)
./install --fonts                 # + Nerd Fonts / Comic Mono into ~/.local/share/fonts
```

`--host` is remembered in `.host`. Package lists live in `hosts/`
(`hosts/default` is shared, `hosts/desktop` adds the niri desktop, and
`hosts/asahi` / `hosts/san-giminiano` pick one). `-n` does a dry run.

Machine-specific app settings live in `<app>/.config/<app>/hosts/<host>.*`;
`install` links the current host's file to `host.kdl` (niri: outputs,
scaling, audio launcher, backlight keys), `host.json` (waybar: temperature
sensor, backlight device) or `host.css` (waybar, wofi: font and padding
sizes) or `host.ini`/`host.toml`/`host.conf` (foot/alacritty/ghostty: font
size), which the main config includes if present. Emacs and neovide pick
their font size by hostname.

## Layout

| Path | What |
|---|---|
| `<app>/.config/<app>/` | one Stow package per app, symlinked into `~/.config` |
| `home/`, `bin/`, `ssh/` | `~/.profile`, `~/.local/bin` scripts, `~/.ssh/config` |
| `theme/palette-{dark,light}` | **the only place colors are defined** |
| `theme/gen` | renders every `*.tmpl` next to itself from the active palette |
| `theme/switch` | toggles dark/light, re-renders and reloads running apps (Mod+Shift+T, waybar button) |
| `system/<host>/` | files for `/` (asahi: battery charge limit, portage keywords, greetd, zram; san-giminiano: nftables, nvidia KMS, sshd, greetd, GRUB config + minimal theme) |
| `system/<host>.services` | runit services `--services` enables (`name`) or disables (`!name`), in order |
| `packages/world` | Portage world set snapshot |
| `packages/void` | Void packages the configs need |
| `suckless/pinned/` | X11 tools as `UPSTREAM` pin + `local.diff` + `config.h` |
| `hooks/pre-commit` | secret scan, shellcheck, theme-in-sync check |

Per-machine files that are never committed: `~/.config/fish/local.fish`,
`~/.config/niri/local.kdl`, `~/.config/git/local`, `~/.ssh/config.d/*.conf`.

## Theme

Dark is `theme/palette-dark` (warm amber/rust), light is `theme/palette-light`
(Rosé Pine Dawn); both have the same keys. `theme/switch [dark|light]` (or
Mod+Shift+T, or the sun/moon button on the bottom waybar) re-renders everything and reloads foot, waybar, niri, tmux, the
emacs daemon and the GTK color-scheme; 4coder flips `default_theme_name`
between `theme-nasr` and `theme-nasr-light` and picks it up on next start.
The active mode lives in `~/.local/state/theme-mode`; `theme/gen` uses it.

Edit a palette, run `theme/gen`, commit both the palette and the
regenerated files (in dark mode, so the repo keeps dark outputs). Templates: foot `colors.ini`, alacritty `colors.toml`, ghostty `colors`, niri `colors.kdl`, waybar
`colors.css`/`colors.json`/`config`, wofi `colors.css`, tmux `colors.conf`, gf2 `gf2_config.ini`,
nvim `lua/ui/palette.lua`, emacs `nasr-theme.el`, greetd `system/asahi/.../greeter` (console
palette for tuigreet), fish `conf.d/colors.fish`
(including fzf).

## suckless

```sh
suckless/pinned/build.sh st              # build in ~/.cache/suckless/st
sudo suckless/pinned/build.sh st install
```

Each tool is checked out at its pinned upstream ref, `local.diff` is applied,
and `config.h` copied in. To upgrade: bump `UPSTREAM`, rebuild, fix any
rejects, regenerate `local.diff`.

## Keys

### niri (Mod = Super)

| Key | Action |
|---|---|
| `Mod+Return` / `Mod+P` | foot / wofi |
| `Mod+E` / `Mod+B` / `Mod+N` | emacs / firefox / 4coder |
| `Mod+H J K L` | focus left / down / up / right |
| `Mod+Ctrl+H J K L` | move column / window |
| `Mod+1..9` / `Mod+Ctrl+1..9` | go to / move to workspace (1 dev, 2 web, 3 term, 4 media) |
| `Mod+U` / `Mod+I` | workspace down / up |
| `Mod+R` / `Mod+F` / `Mod+Shift+F` | cycle width / maximize / fullscreen |
| `Mod+W` / `Mod+V` | tabbed column / float |
| `Mod+O` | overview |
| `Mod+Q` | close |
| `F12` | screenshot |
| media / brightness keys | wpctl, playerctl, brightnessctl |
| `Mod+Shift+/` | all binds |

### tmux (prefix = Alt-a)

| Key | Action |
|---|---|
| `Alt-h j k l` | move between panes |
| `Alt-1..6` | window |
| `Alt-$` / `Alt-%` / `Alt-c` | split right / split down / new window |
| `Alt-z` | zoom pane |
| `prefix Alt-j` | fuzzy session switcher |
| `prefix Alt-o` | open a zoxide dir in a new window |
| `prefix Alt-d` | open a zoxide dir as a session |
| `prefix r` | reload config |

### fish

`z <dir>` jumps (zoxide), `Ctrl-T` files, `Alt-C` dirs, `Ctrl-R` history,
`Ctrl-F` accept suggestion, `Ctrl-E` edit command in `$EDITOR`.
`checkpoint "msg"` stages interactively (`git add -p`) and commits.
`memory <pid|name>` watches a process's RSS.

## Asahi notes

- Battery stops charging at 80% (`system/asahi/etc/udev/rules.d/99-asahi-battery.rules`).
- `speakersafetyd` must stay in the default runlevel, since it protects the speakers.
- Panel backlight is `apple-panel-bl`, keyboard is `kbd_backlight` (you need to be in the `video` group).

## Void notes

- First setup: `./install --packages --system --fonts --services` (from a
  tty: switching seatd to elogind ends a running niri session), then
  `sudo usermod -aG socklog nasr` (read logs with `svlogtail`),
  `chsh -s /usr/bin/fish`, `sudo grub-mkconfig -o /boot/grub/grub.cfg` and
  `sudo xbps-reconfigure -f linux6.18` (microcode, nvidia modeset). Reboot.
- The display runs on the Intel GPU (niri `render-drm-device`); run things on
  the GTX 1050 with `prime-run <cmd>`.
- Firewall drops all inbound traffic and sshd is off. To allow SSH, add a key to
  `~/.ssh/authorized_keys`, uncomment the ssh line in `/etc/nftables.conf`, and
  enable the service again (password logins stay disabled).
- Swap is zram (`zramen`). Logs come from socklog. Seats and
  `XDG_RUNTIME_DIR` come from elogind; seatd's service is off.
- Audio is PulseAudio; volume keys and the waybar module use `pactl`, which
  also works with PipeWire's `pipewire-pulse` on the Asahi machine.
- No NetworkManager (wired, dhcpcd only): the waybar network module falls
  back to `/sys/class/net` and `ip monitor`.
- Login is greetd + tuigreet on tty7 (`system/san-giminiano/etc/greetd`);
  tty1-6 still have text logins, where `start` runs `dbus-run-session niri`.
- Kernel boots with `nokaslr` (`system/san-giminiano/etc/default/grub`; run
  `grub-mkconfig -o /boot/grub/grub.cfg` after changing it). Root btrfs is
  mounted with `compress=zstd:1`.
- `Mod+Y` opens clipboard history (cliphist). `save-state` checkpoints and
  pushes 4coder and the compiler repo.
