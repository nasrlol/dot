#!/usr/bin/env python3
import json
import subprocess


def sh(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout


def main():
    active = sh(["nmcli", "-t", "-f", "type,state,device", "connection", "show", "--active"])
    wifi_dev = eth_dev = None
    for line in active.splitlines():
        parts = line.split(":")
        if len(parts) < 3:
            continue
        typ, _state, dev = parts[0], parts[1], parts[2]
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
        print(json.dumps({"text": f"{icon} {signal}%", "class": "wifi", "tooltip": f"{ssid} ({signal}%)"}))
    elif eth_dev:
        print(json.dumps({"text": f"󰈀 {eth_dev}", "class": "ethernet", "tooltip": f"Ethernet: {eth_dev}"}))
    else:
        print(json.dumps({"text": "󰤮 offline", "class": "disconnected", "tooltip": "Disconnected"}))


if __name__ == "__main__":
    main()
