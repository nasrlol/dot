#!/usr/bin/env python3
"""Long-running waybar module: re-renders on NetworkManager events, and every
30s so the wifi signal strength stays roughly current."""
import json
import queue
import subprocess
import sys
import threading

REFRESH_SECONDS = 30


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def emit():
    active = sh(["nmcli", "-t", "-f", "type,state,device", "connection", "show", "--active"])
    wifi_dev = eth_dev = None
    for line in active.splitlines():
        parts = line.split(":")
        if len(parts) < 3:
            continue
        typ, dev = parts[0], parts[2]
        if typ == "802-11-wireless":
            wifi_dev = dev
        elif typ in ("802-3-ethernet", "ethernet"):
            eth_dev = dev

    if wifi_dev:
        ssid = signal = ""
        for line in sh(["nmcli", "-t", "-f", "active,ssid,signal", "dev", "wifi"]).splitlines():
            parts = line.split(":")
            if len(parts) >= 3 and parts[0] == "yes":
                ssid, signal = parts[1], parts[2]
                break
        icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
        icon = icons[min(int(signal or 0) // 20, 4)]
        out = {"text": f"{icon} {signal}%", "class": "wifi", "tooltip": f"{ssid} ({signal}%)"}
    elif eth_dev:
        out = {"text": f"󰈀 {eth_dev}", "class": "ethernet", "tooltip": f"Ethernet: {eth_dev}"}
    else:
        out = {"text": "󰤮 offline", "class": "disconnected", "tooltip": "Disconnected"}
    print(json.dumps(out), flush=True)


def watch(events):
    proc = subprocess.Popen(["nmcli", "monitor"], stdout=subprocess.PIPE, text=True)
    for line in proc.stdout:
        events.put(line)


def main():
    events = queue.Queue()
    threading.Thread(target=watch, args=(events,), daemon=True).start()
    emit()
    while True:
        try:
            events.get(timeout=REFRESH_SECONDS)
            # nmcli emits bursts of lines per transition; coalesce them
            while True:
                events.get(timeout=0.3)
        except queue.Empty:
            pass
        emit()


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
