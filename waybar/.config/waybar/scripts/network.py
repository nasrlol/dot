#!/usr/bin/env python3
"""Long-running waybar module: re-renders on NetworkManager events, and every
30s so the wifi signal strength stays roughly current.

Without NetworkManager (e.g. dhcpcd + wpa_supplicant) it reads /sys/class/net
and listens to `ip monitor` instead."""
import json
import os
import queue
import shutil
import subprocess
import sys
import threading

REFRESH_SECONDS = 30
HAVE_NMCLI = shutil.which("nmcli") is not None


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def sysfs_devices():
    """(wifi_dev, eth_dev) from the kernel: physical interfaces that are up."""
    wifi_dev = eth_dev = None
    for dev in sorted(os.listdir("/sys/class/net")):
        base = f"/sys/class/net/{dev}"
        if not os.path.exists(f"{base}/device"):  # lo, bridges, tunnels
            continue
        try:
            with open(f"{base}/operstate") as f:
                if f.read().strip() != "up":
                    continue
        except OSError:
            continue
        if os.path.exists(f"{base}/wireless") or os.path.exists(f"{base}/phy80211"):
            wifi_dev = wifi_dev or dev
        else:
            eth_dev = eth_dev or dev
    return wifi_dev, eth_dev


def sysfs_wifi(dev):
    """(ssid, signal%) via iw and /proc/net/wireless (link quality is out of 70)."""
    ssid = signal = ""
    for line in sh(["iw", "dev", dev, "link"]).splitlines():
        line = line.strip()
        if line.startswith("SSID:"):
            ssid = line[5:].strip()
    try:
        with open("/proc/net/wireless") as f:
            for line in f:
                if line.strip().startswith(f"{dev}:"):
                    quality = float(line.split()[2].rstrip("."))
                    signal = str(min(100, round(quality * 100 / 70)))
    except (OSError, IndexError, ValueError):
        pass
    return ssid, signal


def nmcli_devices():
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
    return wifi_dev, eth_dev


def nmcli_wifi():
    for line in sh(["nmcli", "-t", "-f", "active,ssid,signal", "dev", "wifi"]).splitlines():
        parts = line.split(":")
        if len(parts) >= 3 and parts[0] == "yes":
            return parts[1], parts[2]
    return "", ""


def emit():
    wifi_dev, eth_dev = nmcli_devices() if HAVE_NMCLI else sysfs_devices()

    if wifi_dev:
        ssid, signal = nmcli_wifi() if HAVE_NMCLI else sysfs_wifi(wifi_dev)
        out = {"text": f"wifi {signal}%", "class": "wifi", "tooltip": f"{ssid} ({signal}%)"}
    elif eth_dev:
        out = {"text": f"eth {eth_dev}", "class": "ethernet", "tooltip": f"Ethernet: {eth_dev}"}
    else:
        out = {"text": "net offline", "class": "disconnected", "tooltip": "Disconnected"}
    print(json.dumps(out), flush=True)


def watch(events):
    cmd = ["nmcli", "monitor"] if HAVE_NMCLI else ["ip", "monitor", "link", "address"]
    try:
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, text=True)
    except FileNotFoundError:
        return  # no event source; fall back to the periodic refresh
    for line in proc.stdout:
        events.put(line)


def main():
    events = queue.Queue()
    threading.Thread(target=watch, args=(events,), daemon=True).start()
    emit()
    while True:
        try:
            events.get(timeout=REFRESH_SECONDS)
            # nmcli / ip emit bursts of lines per transition; coalesce them
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
