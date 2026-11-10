#!/bin/sh
# Power menu for the custom/power module: pick an action in fuzzel.
# elogind isn't running, so suspend/reboot/poweroff go through sudo.
set -eu

lock=$HOME/.config/swaylock/lock

idle=$(dirname "$0")/idle.sh

# power.sh [lock|suspend|logout|reboot|poweroff|idle] skips the menu (palette uses it)
choice=${1:-}
if [ -z "$choice" ]; then
	if [ "$("$idle" status)" = awake ]; then awake="stay awake: on"; else awake="stay awake: off"; fi
	choice=$(printf 'lock\nsuspend\nlogout\nreboot\npoweroff\n%s\n' "$awake" |
		fuzzel --dmenu --prompt "power " --lines 6) || exit 0
fi

case $choice in
lock) exec "$lock" ;;
suspend)
	# The lock script blocks while swaylock runs, so start it in the
	# background and give it a moment to cover the screen first
	"$lock" &
	sleep 1
	exec sudo -n sh -c 'echo mem > /sys/power/state'
	;;
logout) exec niri msg action quit --skip-confirmation ;;
reboot) exec sudo -n reboot ;;
poweroff) exec sudo -n poweroff ;;
idle | "stay awake"*) exec "$idle" toggle ;;
esac
