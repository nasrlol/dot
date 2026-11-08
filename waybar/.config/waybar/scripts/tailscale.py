#!/usr/bin/env python3
"""Waybar module: tailscale, green when connected and red when not
(style.css). The tooltip has the tailnet, this machine's address, the exit
node if one is in use, and which peers are online.

  tailscale.py          print the waybar JSON
  tailscale.py toggle   tailscale up <-> down (works without sudo because
                        this user is tailscale's operator)
"""
import json
import subprocess
import sys

SIGNAL = 12  # matches "signal" of custom/tailscale in modules.jsonc


def status():
    try:
        out = subprocess.run(["tailscale", "status", "--json"], capture_output=True,
                             text=True, timeout=5).stdout
        d = json.loads(out)
    except (OSError, subprocess.SubprocessError, ValueError):
        return {"text": "tailscale", "class": "disconnected",
                "tooltip": "tailscaled isn't running"}

    state = d.get("BackendState", "?")
    if state != "Running":
        hint = "log in with: tailscale up" if state == "NeedsLogin" else "click to connect"
        return {"text": "tailscale", "class": "disconnected",
                "tooltip": f"tailscale {state.lower()}\n{hint}"}

    me = d.get("Self") or {}
    ips = me.get("TailscaleIPs") or ["?"]
    peers = list((d.get("Peer") or {}).values())
    online = sorted((p for p in peers if p.get("Online")), key=lambda p: p.get("HostName", "").lower())
    exit_node = next((p for p in peers if p.get("ExitNode")), None)

    lines = [f"{(d.get('CurrentTailnet') or {}).get('Name', '?')}",
             f"{me.get('HostName', '?')}  {ips[0]}"]
    if exit_node:
        lines.append(f"exit node {exit_node.get('HostName')}")
    lines += ["", f"{len(online)} of {len(peers)} peers online"]
    lines += [f"  {p.get('HostName')}  {(p.get('TailscaleIPs') or ['?'])[0]}  ({p.get('OS', '?')})"
              for p in online]
    lines += ["", "click to disconnect"]
    return {"text": "tailscale", "class": "connected", "tooltip": "\n".join(lines)}


def toggle():
    running = status()["class"] == "connected"
    subprocess.run(["tailscale", "down" if running else "up"], capture_output=True, timeout=30)
    subprocess.run(["pkill", f"-RTMIN+{SIGNAL}", "-x", "waybar"])


if __name__ == "__main__":
    if sys.argv[1:] == ["toggle"]:
        toggle()
    else:
        print(json.dumps(status()))
