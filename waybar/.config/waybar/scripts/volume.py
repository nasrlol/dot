#!/usr/bin/env python3
import json
import re
import subprocess


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def main():
    muted = "yes" in sh(["pactl", "get-sink-mute", "@DEFAULT_SINK@"])
    m = re.search(r"(\d+)%", sh(["pactl", "get-sink-volume", "@DEFAULT_SINK@"]))
    vol = int(m.group(1)) if m else 0

    if muted:
        icon, cls = "󰝟", "muted"
        text = f"{icon} muted"
    else:
        icon = "󰕾" if vol >= 60 else ("󰖀" if vol >= 20 else "󰕿")
        cls = "normal"
        text = f"{icon} {vol}%"

    print(json.dumps({"text": text, "class": cls, "tooltip": f"Volume {vol}%"}))


if __name__ == "__main__":
    main()
