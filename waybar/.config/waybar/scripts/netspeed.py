#!/usr/bin/env python3
"""Long-running waybar module: download/upload speed of the default-route
interface, from the kernel's byte counters in /sys/class/net."""
import json
import sys
import time

INTERVAL = 2


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


def main():
    prev = None
    while True:
        iface = default_iface()
        try:
            now = (iface, time.monotonic(), *counters(iface)) if iface else None
        except OSError:
            now = None

        if now is None:
            out = {"text": "↓ 0B ↑ 0B", "class": "offline", "tooltip": "No default route"}
        elif prev is None or prev[0] != iface:
            out = {"text": "↓ … ↑ …", "class": "idle", "tooltip": iface}
        else:
            dt = now[1] - prev[1]
            down, up = (now[2] - prev[2]) / dt, (now[3] - prev[3]) / dt
            cls = "active" if down + up >= 100_000 else "idle"
            out = {
                "text": f"↓ {human(down)} ↑ {human(up)}",
                "class": cls,
                "tooltip": f"{iface}: {down * 8 / 1e6:.1f} Mbit/s down, {up * 8 / 1e6:.1f} Mbit/s up",
            }
        print(json.dumps(out), flush=True)
        prev = now
        time.sleep(INTERVAL)


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
