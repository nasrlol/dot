#!/usr/bin/env python3
"""Waybar module: how many todos are in ~/todo.txt, plus the top one.
One item per line; blank lines are ignored."""
import html
import json
from pathlib import Path

TODO = Path.home() / "todo.txt"
# Keeps the module short so the window title still fits
MAX_LEN = 40

try:
    items = [l.strip() for l in TODO.read_text().splitlines() if l.strip()]
except FileNotFoundError:
    items = []

if items:
    top = items[0]
    if len(top) > MAX_LEN:
        top = top[: MAX_LEN - 1] + "…"
    text, tooltip, cls = f"{len(items)} · {top}", "\n".join(items), "todos"
else:
    text, tooltip, cls = "no todos", "todo.txt is empty", "empty"

# waybar treats text as Pango markup, so a stray & or < would break the label
print(json.dumps({"text": html.escape(text), "tooltip": html.escape(tooltip), "class": cls}))
