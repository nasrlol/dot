#!/bin/sh
# Power menu for the custom/power module: pick an action in fuzzel.
# elogind isn't running, so suspend/reboot/poweroff go through sudo.
set -eu

lock=$HOME/.config/swaylock/lock

choice=$(printf 'lock\nsuspend\nlogout\nreboot\npoweroff\n' |
	fuzzel --dmenu --prompt "power " --lines 5) || exit 0

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
esac
