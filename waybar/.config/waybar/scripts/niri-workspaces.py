#!/usr/bin/env python3
import json
import os
import subprocess
import sys

# Generated from theme/palette by theme/gen
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "colors.json")) as f:
    C = json.load(f)

workspaces = []

# Absolute line height in Pango units (px * 1024). Tuned to the rendered bar
# height (set by the right-hand modules, not "height") so the focused-workspace
# background is flush with the bar's top and bottom edges at 1.1x scale.
LINE_HEIGHT = 46 * 1024


def emit():
    parts = []
    ordered = sorted(workspaces, key=lambda w: w["idx"])
    # Lets CSS extend the first workspace's highlight into the bar's rounded corner
    first_class = ""
    if ordered:
        if ordered[0].get("is_urgent"):
            first_class = "first-urgent"
        elif ordered[0].get("is_focused"):
            first_class = "first-focused"
    for i, w in enumerate(ordered):
        idx = w.get("name") or w["idx"]
        # The first workspace's left padding comes from the CSS strip instead
        lead = "" if i == 0 else " "
        if w.get("is_urgent"):
            parts.append(f"<span background='{C["rust"]}' color='{C["bg"]}'>{lead}{idx} </span>")
        elif w.get("is_focused"):
            parts.append(f"<span background='{C["fg"]}' color='{C["bg"]}'><b>{lead}{idx} </b></span>")
        else:
            parts.append(f"<span color='{C["fg_dim"]}'>{lead}{idx} </span>")
    text = f"<span line_height='{LINE_HEIGHT}'>{' '.join(parts)}</span>"
    print(json.dumps({"text": text, "class": first_class}), flush=True)


def apply_activation(ev):
    act_id = ev["id"]
    focused = ev.get("focused", True)
    for w in workspaces:
        if w["id"] == act_id:
            w["is_active"] = True
            if focused:
                w["is_focused"] = True
        else:
            w["is_active"] = False
            if focused:
                w["is_focused"] = False


def main():
    global workspaces
    proc = subprocess.Popen(
        ["niri", "msg", "--json", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )
    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            ev = json.loads(line)
        except json.JSONDecodeError:
            continue

        if "WorkspacesChanged" in ev:
            workspaces = ev["WorkspacesChanged"]["workspaces"]
            emit()
        elif "WorkspaceActivated" in ev:
            apply_activation(ev["WorkspaceActivated"])
            emit()
        elif "WorkspaceUrgencyChanged" in ev:
            d = ev["WorkspaceUrgencyChanged"]
            for w in workspaces:
                if w["id"] == d["id"]:
                    w["is_urgent"] = d["urgent"]
            emit()


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
