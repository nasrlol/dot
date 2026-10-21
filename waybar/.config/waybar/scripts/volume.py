#!/usr/bin/env python3
"""Long-running waybar module: re-renders only when PulseAudio/PipeWire reports a change.

Tracks the sink audio is actually playing on, not just @DEFAULT_SINK@: apps can
stay routed to e.g. bluetooth headphones while the default is still the speakers.

  volume.py            run the module
  volume.py up|down    change the active sink's volume by 5%
  volume.py mute       toggle mute on the active sink
"""
import json
import subprocess
import sys


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def active_sink():
    """Default sink if it's playing, else the first sink that is, else the default."""
    sinks = json.loads(sh(["pactl", "-f", "json", "list", "sinks"]) or "[]")
    if not sinks:
        return None
    default = sh(["pactl", "get-default-sink"]).strip()
    running = [s for s in sinks if s["state"] == "RUNNING"]
    for s in running:
        if s["name"] == default:
            return s
    if running:
        return running[0]
    return next((s for s in sinks if s["name"] == default), sinks[0])


# Text labels
ICON_MUTED = "mute"
ICON_LEVELS = ["vol", "vol", "vol"]  # low, mid, high
ICON_HEADPHONES = "hp"
ICON_BT_HEADPHONES = "bt hp"


def device_label(sink):
    props = sink["properties"]
    hints = " ".join(
        props.get(k, "") for k in ("device.form_factor", "device.icon_name", "device.bus")
    )
    if "headset" in hints or "headphone" in hints:
        return ICON_BT_HEADPHONES if "bluetooth" in hints else ICON_HEADPHONES
    if "bluetooth" in hints:
        return ICON_BT_HEADPHONES
    return None


def emit():
    sink = active_sink()
    if sink is None:
        print(json.dumps({"text": ICON_MUTED, "class": "muted", "tooltip": "No output"}), flush=True)
        return

    vols = [int(c["value_percent"].rstrip("%")) for c in sink["volume"].values()]
    vol = round(sum(vols) / len(vols)) if vols else 0
    name = sink["description"]
    dev = device_label(sink)

    if sink["mute"]:
        text, cls = ICON_MUTED, "muted"
    else:
        label = dev or ICON_LEVELS[min(vol * len(ICON_LEVELS) // 100, len(ICON_LEVELS) - 1)]
        text, cls = f"{label} {vol}%", "normal"
    if dev:
        cls += " headphones"

    print(json.dumps({"text": text, "class": cls, "tooltip": f"{name}: {vol}%"}), flush=True)


def act(cmd):
    sink = active_sink()
    if sink is None:
        return
    name = sink["name"]
    if cmd == "mute":
        sh(["pactl", "set-sink-mute", name, "toggle"])
    elif cmd == "up":
        # cap at 100% like `wpctl set-volume -l 1.0`
        vols = [int(c["value_percent"].rstrip("%")) for c in sink["volume"].values()]
        sh(["pactl", "set-sink-volume", name, f"{min(max(vols, default=0) + 5, 100)}%"])
    elif cmd == "down":
        sh(["pactl", "set-sink-volume", name, "-5%"])


def main():
    emit()
    proc = subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE, text=True)
    for line in proc.stdout:
        # "Event 'change' on sink #56", "... on sink-input #78" (stream moved/started),
        # "... on server" (default sink switched)
        if " on sink" in line or " on server" in line:
            emit()


if __name__ == "__main__":
    try:
        if len(sys.argv) > 1:
            act(sys.argv[1])
        else:
            main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
