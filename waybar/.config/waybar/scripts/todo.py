#!/usr/bin/env python3
"""Waybar module: how many todos are in ~/todo.txt, with the list in the tooltip.
One item per line; blank lines are ignored."""
import html
import json
from pathlib import Path

TODO = Path.home() / "todo.txt"

try:
    items = [l.strip() for l in TODO.read_text().splitlines() if l.strip()]
except FileNotFoundError:
    items = []

if items:
    text, tooltip, cls = f"todo {len(items)}", "\n".join(items), "todos"
else:
    text, tooltip, cls = "todo 0", "todo.txt is empty", "empty"

# waybar treats text as Pango markup, so a stray & or < would break the label
print(json.dumps({"text": html.escape(text), "tooltip": html.escape(tooltip), "class": cls}))
