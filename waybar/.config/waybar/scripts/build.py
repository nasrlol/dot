#!/usr/bin/env python3
"""Waybar module: result of the last build-notify run.
Reads $XDG_STATE_HOME/build/last (status, project, seconds, first error, tab
separated). build-notify (and emacs, see nasr-build.el) sends RTMIN+9 so this refreshes as soon as a build ends."""
import html
import json
import os
import re
import time
from pathlib import Path

state = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state")) / "build"

try:
    status, project, secs, err = (state / "last").read_text().rstrip("\n").split("\t", 3)
except (FileNotFoundError, ValueError):
    # never empty: a hidden module would shift the todo/build pair off the notch
    print(json.dumps({"text": "no builds yet", "class": "none"}))
    raise SystemExit

# when the build finished: the clock time today, otherwise the date too
done = (state / "last").stat().st_mtime
same_day = time.strftime("%F", time.localtime(done)) == time.strftime("%F")
at = time.strftime("%H:%M" if same_day else "%d %b %H:%M", time.localtime(done))
full = time.strftime("%A %d %B, %H:%M:%S", time.localtime(done))

# gcc/clang-style diagnostics in the build output
DIAG = re.compile(r":\d+(?::\d+)?: (fatal error|error|warning):")
try:
    kinds = [m[1] for m in map(DIAG.search, (state / "log").read_text(errors="replace").splitlines()) if m]
except FileNotFoundError:
    kinds = []
errors = sum(k != "warning" for k in kinds)
warnings = len(kinds) - errors


def plural(n, word):
    return f"{n} {word}{'' if n == 1 else 's'}"


counts = ", ".join(plural(n, w) for n, w in ((errors, "error"), (warnings, "warning")) if n)

if status == "0":
    text, cls = f"● {project} {secs}s  {at}", "ok"
    tooltip = f"{project}: built in {secs}s\n{full}" + (f"\n{counts}" if counts else "")
else:
    text, cls = f"● {project}  {plural(errors, 'error') if errors else 'failed'}  {at}", "failed"
    full += f"\n{counts}" if counts else ""
    tooltip = (f"{project}: failed after {secs}s\n{full}\n{err}" if err
               else f"{project}: failed (exit {status})\n{full}")

# waybar treats text as Pango markup, so a stray & or < would break the label
print(json.dumps({"text": html.escape(text), "tooltip": html.escape(tooltip), "class": cls}))
