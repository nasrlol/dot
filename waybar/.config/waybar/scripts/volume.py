#!/usr/bin/env python3
"""Long-running waybar module: re-renders only when PulseAudio/PipeWire reports a change."""
import json
import re
import subprocess
import sys


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def emit():
    muted = "yes" in sh(["pactl", "get-sink-mute", "@DEFAULT_SINK@"])
    m = re.search(r"(\d+)%", sh(["pactl", "get-sink-volume", "@DEFAULT_SINK@"]))
    vol = int(m.group(1)) if m else 0

    if muted:
        text, cls = "󰝟 muted", "muted"
    else:
        icon = "󰕾" if vol >= 60 else ("󰖀" if vol >= 20 else "󰕿")
        text, cls = f"{icon} {vol}%", "normal"

    print(json.dumps({"text": text, "class": cls, "tooltip": f"Volume {vol}%"}), flush=True)


def main():
    emit()
    proc = subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE, text=True)
    for line in proc.stdout:
        # "Event 'change' on sink #56", "... on server" (default sink switched)
        if " on sink " in line or " on server" in line:
            emit()


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
