# Configuration Color Scheme Update — nasr theme

**Date:** 2026-06-12  
**Theme:** Warm amber/rust/sepia on dark (#0D1117 background)  
**Based on:** /opt/4cc/build/themes/theme-nasr.4coder

## Color Palette

| Component | Color | Hex | Purpose |
|-----------|-------|-----|---------|
| Background | Near-black | `#0D1117` | Primary dark background |
| Foreground | Warm tan | `#C4A882` | Default text color |
| Cursor | Gold | `#F0A030` | Insert mode cursor |
| Cursor BG | Rust | `#C04018` | Cursor background highlight |
| Keyword | Amber | `#D48B30` | Keywords, active highlights |
| String | Rust-brown | `#B86030` | String constants |
| Type | Medium brown | `#B87040` | Types, declarations |
| Comment | Dim brown | `#6B5A45` | Comments, less important text |
| Accent | Pop gold | `#D4A030` | Highlights, pop accents |
| Pop/Error | Orange-red | `#DC4A20` | Errors, special chars |
| Border | Very dark | `#241A10` | Borders, line numbers bg |
| Line Number | Brown | `#5A4A38` | Line number text |
| Bar/Muted | Mid-brown | `#8B7355` | Status bar, muted text |

## Applied Updates

### ✅ Completed
- **alacritty** (`alacritty.toml`) — Terminal emulator
  - Background: `#0D1117`, Foreground: `#C4A882`
  - Cursor: `#F0A030` on `#C04018`
  - Terminal colors mapped to warm palette

- **neovim** (`lua/ui/colors.lua`) — Text editor
  - Custom color palette with warm tones
  - All syntax highlighting groups updated

- **vim** (`vim/vimrc`) — Vi clone
  - Manual highlight groups for warm theme
  - Fallback to basic colors if gruvbox unavailable

- **helix** (`helix/config.toml` + `helix/themes/nasr.toml`) — Editor
  - Created custom `nasr.toml` theme
  - All UI and syntax elements themed

- **zathura** (`zathura/zathurarc`) — PDF viewer
  - Recolor enabled with warm palette
  - UI colors matched to theme

- **btop** (`btop/btop.conf` + `btop/themes/nasr.theme`) — System monitor
  - Created custom theme file
  - Temperature/graph colors in warm palette

- **tmux** (`tmux/tmux.conf`) — Terminal multiplexer
  - Already themed (was pre-applied)
  - Status bar, borders, highlights all consistent

- **hyprland** (`hypr/hyprland.conf`) — Window manager
  - Already themed with warm borders
  - Active: `#D48B30`, Inactive: `#1F1610`

- **dwm** (`suckless/dwm-6.5/config.h`) — Window manager (X11)
  - All color definitions updated
  - Consistent with Hyprland theme

- **dmenu** (`suckless/dmenu/config.h`) — Application launcher
  - Color scheme updated to nasr theme
  - Foreground: `#C4A882`, Selection: `#D48B30` on `#0D1117`

- **st** (`suckless/st/config.h`) — Terminal emulator
  - Already themed with nasr palette
  - 16-color + extended colors defined

- **waybar** (`waybar/style.css`) — Status bar
  - Background: `#0D1117`
  - Active border: `#D48B30`

- **wofi** (`wofi/style.css`) — Application launcher
  - Window: `#1A1208` background
  - Selection: `#F0A030` on `#1F1610`

- **zed** (`zed/settings.json`) — Editor
  - Set dark theme preference
  - Note: Full custom theming requires Zed extensions

## Unused/Legacy Configs

These are present but may not be actively used. Review before cleanup:

| Directory | Size | Status | Notes |
|-----------|------|--------|-------|
| `discord/` | 686M | Likely cache | Contains app cache + settings |
| `BraveSoftware/` | 633M | Browser cache | Not user config; safe to clean |
| `mozilla/` | 479M | Browser cache | Firefox profiles + cache |
| `Code - OSS/` | 71M | VS Code cache | Could have user settings |
| `JetBrains/` | 32M | IDE cache | IntelliJ IDEA/CLion cache |
| `chromium/` | 30M | Browser cache | Chrome/Chromium profiles |
| `emacs/` | 15M | Emacs config + cache | Has custom elisp; keep |
| `sublime-text/` | 44K | Editor | Not actively used |
| `fish/` | 36K | Shell | Using zsh; could remove |
| `kitty/` | Unknown | Terminal | Using alacritty; could remove |
| `ghostty/` | Unknown | Terminal | Using alacritty; could remove |

## Recommendations for Config Improvement

### 1. **Consolidate Theme Definitions**
   **Issue:** Colors are defined in multiple places (CSS, TOML, C headers, TOML)
   
   **Recommendation:** Create a central `~/.config/theme-nasr.json` or `theme-nasr.sh` that exports all colors as environment variables or constants:
   ```bash
   # ~/.config/theme-nasr.env
   export COLOR_BG="#0D1117"
   export COLOR_FG="#C4A882"
   # ... etc
   ```
   Then source it in shell configs. This makes theme changes atomic.

### 2. **Remove Unused Editors**
   You have configs for:
   - `sublime-text/` (44K) — not actively used
   - `fish/` (36K) — using zsh instead
   - `kitty/` — using alacritty
   - `ghostty/` — using alacritty
   - `Code - OSS/` (71M) — if you use Zed instead
   
   **Action:** Back these up, then delete if not using.

### 3. **Browser Cache ≠ Config**
   `BraveSoftware/`, `mozilla/`, `chromium/` are mostly cache.
   
   **Recommendation:** Move these outside `.config` to `~/.cache/`:
   ```bash
   mv ~/.config/mozilla ~/.cache/firefox
   mv ~/.config/chromium ~/.cache/chromium
   mv ~/.config/BraveSoftware ~/.cache/brave
   ```
   And set environment variables:
   ```bash
   export FIREFOX_HOME=~/.cache/firefox
   export CHROMIUM_USER_DATA_DIR=~/.cache/chromium
   ```

### 4. **Organize by Function**
   Current structure mixes apps, caches, and build configs:
   ```
   ~/.config/
   ├── editors/        (nvim, vim, helix, zed)
   ├── shells/         (bash, zsh, fish)
   ├── terminals/      (alacritty, st config)
   ├── wm/             (hypr, dwm-6.5, waybar, wofi)
   ├── tools/          (tmux, lazygit, ctags, etc)
   ├── apps/           (discord, obsidian, etc — but configs only)
   └── build/          (suckless/ source code)
   ```

### 5. **Document Shell Keybindings Centrally**
   You have keybindings in:
   - `tmux.conf` (M-a prefix, C-hjkl panes)
   - `hyprland.conf` (various)
   - `keybindings.json` (VS Code, Zed)
   
   **Recommendation:** Create `~/.config/keybindings/README.md` documenting the unified key scheme:
   ```
   - C-hjkl: Pane navigation (vim-like, consistent across tmux/vim/nvim)
   - M-1..6: Window/workspace switching
   - M-a: tmux prefix
   - (etc)
   ```

### 6. **Git Config Duplication**
   You have both `git/` and system git config. Document which takes precedence:
   ```bash
   # In ~/.config/git/config or ~/.config/git/config.local
   [include]
       path = ~/.config/git/config.local  # Machine-specific
   ```

### 7. **Missing Light Theme**
   Your configs are dark-only. Consider:
   - Define a light palette variant in color files
   - Add toggle in tmux: `bind <key> source-file ~/.config/theme-light.conf`
   - Document how to switch (useful for presentations)

### 8. **Obsolete/Stale Comments**
   Found in `suckless/dwm-6.5/config.h`:
   ```c
   // {"neovide",             NULL,   NULL,   1 << 0, 0, -1},  // commented out
   ```
   Remove dead code or document why it's kept.

### 9. **Remove Browser Cruft**
   These are auto-generated and shouldn't be in .config:
   - `dconf/` — GNOME settings database
   - `gtk-3.0/` — GTK settings (auto-generated)
   
   These can usually be regenerated. Safe to delete if not using GNOME.

### 10. **Create a .config Audit Script**
   ```bash
   #!/bin/bash
   # ~/.config/audit.sh
   echo "=== Largest directories ==="
   du -sh ../* | sort -hr | head -10
   echo "=== Likely cache directories ==="
   find . -name "__pycache__" -o -name ".cache" -o -name "*.log" | head -20
   echo "=== Unused tools (check if installed) ==="
   for dir in sublime-text fish kitty; do
     command -v "${dir%%-*}" >/dev/null 2>&1 || echo "  $dir: NOT INSTALLED"
   done
   ```

## Next Steps

### Immediate (safe)
1. ✅ Theme all active apps (done)
2. Run the audit script to find actual unused configs
3. Back up `~/.config` to external drive before cleanup

### Short-term (review first)
1. Delete unused editor configs after confirming they're not needed
2. Move browser cache out of `.config`
3. Create central theme definition file

### Long-term (nice-to-have)
1. Reorganize into semantic folders
2. Document keybinding scheme
3. Create theme switcher (dark/light toggle)

## Files Modified

```
alacritty/alacritty.toml
helix/config.toml
helix/themes/nasr.toml (NEW)
nvim/lua/ui/colors.lua
vim/vimrc
zathura/zathurarc
btop/btop.conf
btop/themes/nasr.theme (NEW)
zed/settings.json
waybar/style.css
wofi/style.css
suckless/dwm-6.5/config.h
suckless/dmenu/config.h
```

## Testing Checklist

- [ ] Restart alacritty — verify warm colors
- [ ] Open neovim — check syntax highlighting
- [ ] Run btop — verify monitor colors
- [ ] View PDF in zathura — check recolor mode
- [ ] Launch wofi (M-p in hyprland or dwm) — verify selection color
- [ ] Check tmux status bar — border colors
- [ ] Verify waybar colors match background
- [ ] Test dmenu in dwm — selection contrast good

---

**Note:** Some configs (discord, obsidian, etc.) use built-in themes not easily customizable via config files. The color scheme is applied where possible; GUI theme selections may still differ from terminal apps.
