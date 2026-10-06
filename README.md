# dotfiles

Gentoo on an Apple Silicon MacBook (Asahi), niri + waybar + foot + fish,
nvim and emacs. One warm amber palette across everything.

## Install

```sh
git clone git@github.com:nasrlol/dot ~/dotfiles
cd ~/dotfiles
./install --host asahi            # link packages with GNU Stow
./install --system                # + udev/portage files into /etc (sudo)
./install --packages              # + emerge everything in packages/world
```

`--host` is remembered in `.host`. Package lists live in `hosts/`
(`hosts/default` is shared, `hosts/asahi` adds the desktop). `-n` does a dry run.

## Layout

| Path | What |
|---|---|
| `<app>/.config/<app>/` | one Stow package per app, symlinked into `~/.config` |
| `home/`, `bin/`, `ssh/` | `~/.profile`, `~/.local/bin` scripts, `~/.ssh/config` |
| `theme/palette` | **the only place colors are defined** |
| `theme/gen` | renders every `*.tmpl` next to itself from the palette |
| `system/` | files for `/etc` (battery charge limit, portage keywords, greetd) |
| `packages/world` | Portage world set snapshot |
| `suckless/pinned/` | X11 tools as `UPSTREAM` pin + `local.diff` + `config.h` |
| `hooks/pre-commit` | secret scan, shellcheck, theme-in-sync check |

Per-machine files that are never committed: `~/.config/fish/local.fish`,
`~/.config/git/local`, `~/.ssh/config.d/*.conf`.

## Theme

Edit `theme/palette`, run `theme/gen`, commit both the palette and the
regenerated files. Templates: foot `colors.ini`, niri `colors.kdl`, waybar
`colors.css`/`colors.json`/`config`, wofi `colors.css`, tmux `colors.conf`,
nvim `lua/ui/palette.lua`, emacs `nasr-theme.el`, greetd `greeter` (console
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

- Battery stops charging at 80% (`system/etc/udev/rules.d/99-asahi-battery.rules`).
- `speakersafetyd` must stay in the default runlevel, since it protects the speakers.
- Panel backlight is `apple-panel-bl`, keyboard is `kbd_backlight` (you need to be in the `video` group).
