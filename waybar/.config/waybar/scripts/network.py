#!/usr/bin/env python3
"""Long-running waybar module: network connection and speed in one.

The bar shows download/upload speed of the default-route interface, green
when connected (style.css) and "offline" in red when not. The tooltip has
the connection details: network, signal, frequency, link speed, IP, gateway.

Speeds come from the kernel's byte counters every INTERVAL seconds. The
connection details come from nmcli, re-read when NetworkManager reports a
change (nmcli monitor) and every REFRESH_SECONDS so the signal stays current.
"""
import json
import subprocess
import sys
import threading
import time

INTERVAL = 2
REFRESH_SECONDS = 30

changed = threading.Event()


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


# ── connection details (nmcli) ────────────────────────────────────────────


def ip_info(dev):
    """'ip 192.168.0.10/24', 'gateway 192.168.0.1' for the device, if any"""
    out = sh(["nmcli", "-g", "IP4.ADDRESS,IP4.GATEWAY", "dev", "show", dev]).splitlines()
    lines = []
    if out and out[0]:
        lines.append(f"ip {out[0].split(' | ')[0]}")
    if len(out) > 1 and out[1]:
        lines.append(f"gateway {out[1]}")
    return lines


def connection():
    """Tooltip lines describing the active connection, or None when offline"""
    active = sh(["nmcli", "-t", "-f", "type,device", "connection", "show", "--active"])
    wifi_dev = eth_dev = None
    for line in active.splitlines():
        typ, _, dev = line.partition(":")
        if typ == "802-11-wireless":
            wifi_dev = dev
        elif typ in ("802-3-ethernet", "ethernet"):
            eth_dev = dev

    if wifi_dev:
        fields = "active,ssid,signal,freq,rate,security,chan"
        info = {}
        for line in sh(["nmcli", "-t", "-f", fields, "dev", "wifi"]).splitlines():
            parts = line.split(":")
            if len(parts) >= 7 and parts[0] == "yes":
                info = dict(zip(fields.split(","), parts))
                break
        return [f"{info.get('ssid', '?')}  ({info.get('signal', '?')}%)",
                f"{info.get('freq', '?')}, channel {info.get('chan', '?')}, {info.get('rate', '?')}",
                f"security {info.get('security') or 'none'}",
                *ip_info(wifi_dev), f"device {wifi_dev}"]
    if eth_dev:
        return ["ethernet", *ip_info(eth_dev), f"device {eth_dev}"]
    return None


def watch():
    proc = subprocess.Popen(["nmcli", "monitor"], stdout=subprocess.PIPE,
                            stderr=subprocess.DEVNULL, text=True)
    for _ in proc.stdout:
        changed.set()


# ── speed (kernel counters) ───────────────────────────────────────────────


def default_iface():
    """Interface of the default IPv4 route, or None when offline."""
    try:
        with open("/proc/net/route") as f:
            next(f)
            for line in f:
                parts = line.split()
                if parts[1] == "00000000" and int(parts[3], 16) & 2:  # RTF_GATEWAY
                    return parts[0]
    except (OSError, StopIteration, IndexError):
        pass
    return None


def counters(iface):
    base = f"/sys/class/net/{iface}/statistics/"
    with open(base + "rx_bytes") as rx, open(base + "tx_bytes") as tx:
        return int(rx.read()), int(tx.read())


def human(rate):
    """Bytes/s -> short label like 840K or 2.1M."""
    for unit in ("B", "K", "M", "G"):
        if rate < 1000 or unit == "G":
            break
        rate /= 1000
    return f"{rate:.1f}{unit}" if rate < 10 and unit != "B" else f"{rate:.0f}{unit}"


# ── main loop ─────────────────────────────────────────────────────────────


def main():
    threading.Thread(target=watch, daemon=True).start()
    details, refreshed = connection(), time.monotonic()
    prev = None
    while True:
        # nmcli prints a burst of lines per change; one re-read covers them
        if changed.is_set() or time.monotonic() - refreshed >= REFRESH_SECONDS:
            changed.clear()
            details, refreshed = connection(), time.monotonic()

        iface = default_iface()
        try:
            now = (iface, time.monotonic(), *counters(iface)) if iface else None
        except OSError:
            now = None

        if details is None or now is None:
            out = {"text": "offline", "class": "disconnected", "tooltip": "not connected"}
        elif prev is None or prev[0] != iface:
            out = {"text": "↓ … ↑ …", "class": "connected", "tooltip": "\n".join(details)}
        else:
            dt = now[1] - prev[1]
            down, up = (now[2] - prev[2]) / dt, (now[3] - prev[3]) / dt
            out = {
                "text": f"↓ {human(down)} ↑ {human(up)}",
                "class": "connected",
                "tooltip": "\n".join([*details, "",
                                      f"{down * 8 / 1e6:.1f} Mbit/s down, {up * 8 / 1e6:.1f} Mbit/s up"]),
            }
        print(json.dumps(out), flush=True)
        prev = now
        # wake early when NetworkManager reports a change
        changed.wait(INTERVAL)


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
