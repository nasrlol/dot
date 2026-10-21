#!/bin/sh
# Waybar module: current theme mode for the custom/theme toggle (see theme/switch).
# waybar restarts this on every switch (theme/switch sends SIGUSR2), so print once.
mode=$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/theme-mode" 2>/dev/null || echo dark)
if [ "$mode" = dark ]; then other=light; else other=dark; fi
printf '{"alt": "%s", "class": "%s", "tooltip": "%s mode, click for %s"}\n' "$mode" "$mode" "$mode" "$other"
