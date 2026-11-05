#!/usr/bin/env python3
"""Waybar module: unread mail count from mu, newest senders/subjects in the tooltip.

Uses the same query as mu4e's "Unread" bookmark (nasr-mail.el), so mailing
lists don't count."""
import html
import json
import subprocess

QUERY = "flag:unread AND NOT flag:trashed AND NOT list:/.+/"
TOOLTIP_MAX = 10

# mu exits non-zero when nothing matches, so only stdout matters
try:
    out = subprocess.run(
        ["mu", "find", "--sortfield=date", "--reverse", "--fields=f\ts", QUERY],
        capture_output=True,
        text=True,
    ).stdout
except FileNotFoundError:
    # No mu on this host: empty text hides the module
    print(json.dumps({"text": "", "class": "idle"}))
    raise SystemExit
items = [line for line in out.splitlines() if line.strip()]

if items:
    lines = [line.replace("\t", "  ", 1) for line in items[:TOOLTIP_MAX]]
    if len(items) > TOOLTIP_MAX:
        lines.append(f"… and {len(items) - TOOLTIP_MAX} more")
    text, tooltip, cls = f"mail {len(items)}", "\n".join(lines), "unread"
else:
    text, tooltip, cls = "mail 0", "No unread mail", "empty"

# waybar treats text as Pango markup, so a stray & or < would break the label
print(json.dumps({"text": html.escape(text), "tooltip": html.escape(tooltip), "class": cls}))
