#!/usr/bin/env python3
"""Waybar module: result of the last build-notify run.
Reads $XDG_STATE_HOME/build/last (status, project, seconds, first error, tab
separated). build-notify sends RTMIN+9 so this refreshes as soon as a build ends."""
import html
import json
import os
from pathlib import Path

state = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state")) / "build"

try:
    status, project, secs, err = (state / "last").read_text().rstrip("\n").split("\t", 3)
except (FileNotFoundError, ValueError):
    print(json.dumps({"text": "", "class": "none"}))
    raise SystemExit

if status == "0":
    text, cls, tooltip = f"● {project} {secs}s", "ok", f"{project}: built in {secs}s"
else:
    text, cls = f"● {project}", "failed"
    tooltip = f"{project}: failed after {secs}s\n{err}" if err else f"{project}: failed (exit {status})"

# waybar treats text as Pango markup, so a stray & or < would break the label
print(json.dumps({"text": html.escape(text), "tooltip": html.escape(tooltip), "class": cls}))
