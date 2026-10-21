#!/usr/bin/env python3
"""Long-running waybar module: shows the MPRIS player that's currently playing.

Hidden (empty text) when nothing is playing. Independent of niri, so it shows
regardless of which workspace the player's window lives on.
"""
import html
import json
import subprocess
import sys

# Leaves room for the window title next to it, clear of the notch
MAX_LEN = 40

ICON_PLAY = "▶\ufe0e"
FMT = "{{status}}\t{{playerName}}\t{{artist}}\t{{title}}"


def playing():
    """(player, artist, title) of the first playing player, or None."""
    out = subprocess.run(
        ["playerctl", "--all-players", "metadata", "--format", FMT],
        capture_output=True,
        text=True,
    ).stdout
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) == 4 and parts[0] == "Playing":
            return parts[1], parts[2].strip(), parts[3].strip()
    return None


def emit():
    p = playing()
    if p is None:
        print(json.dumps({"text": "", "class": "stopped"}), flush=True)
        return
    player, artist, title = p
    label = f"{artist} – {title}" if artist and title else (title or artist or player)
    full = label
    if len(label) > MAX_LEN:
        label = label[: MAX_LEN - 1] + "…"
    print(
        json.dumps(
            {
                "text": f"{ICON_PLAY}  {html.escape(label)}",
                "tooltip": html.escape(f"{player}: {full}"),
                "class": "playing",
            }
        ),
        flush=True,
    )


def main():
    emit()
    # --follow prints a line whenever any player's status/metadata changes (and
    # an empty one when a player goes away); re-query all players each time so
    # a paused player doesn't hide another that is still playing.
    proc = subprocess.Popen(
        ["playerctl", "--all-players", "--follow", "metadata", "--format", FMT],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
    )
    for _ in proc.stdout:
        emit()


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
