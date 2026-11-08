#!/bin/sh
# Idle handling: lock after 5 min, power off displays after 6 min, lock before
# sleep. "Stay awake" just stops swayidle; turning it back on restarts it.
#   idle.sh start    run swayidle (niri spawns this at startup)
#   idle.sh toggle   stay awake <-> normal idle
#   idle.sh status   "awake" while swayidle isn't running, else "normal"
set -eu

lock=$HOME/.config/swaylock/lock

case ${1:-status} in
start)
	exec swayidle \
		timeout 300 "$lock" \
		timeout 360 "niri msg action power-off-monitors" \
		resume "niri msg action power-on-monitors" \
		before-sleep "$lock"
	;;
toggle)
	if pgrep -x swayidle >/dev/null; then
		pkill -x swayidle
		notify-send -a idle "stay awake" "screen won't lock or turn off" 2>/dev/null || true
	elif ! command -v swayidle >/dev/null; then
		notify-send -a idle "swayidle isn't installed" "nothing locks the screen when idle" 2>/dev/null || true
	else
		# niri spawn so swayidle outlives this script and the menu
		niri msg action spawn -- "$0" start
		notify-send -a idle "idle back on" "locks after 5 min" 2>/dev/null || true
	fi
	;;
status)
	if pgrep -x swayidle >/dev/null; then echo normal; else echo awake; fi
	;;
esac
