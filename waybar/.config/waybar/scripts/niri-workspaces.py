#!/usr/bin/env python3
import json
import os
import subprocess
import sys

# Generated from theme/palette by theme/gen
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "colors.json")) as f:
    C = json.load(f)

workspaces = []
# Output name -> logical x, so monitor groups follow the physical left-to-right layout
output_x = {}

# Nerd Font half-circles that round off the highlighted workspace's ends
CAP_L = "\ue0b6"
CAP_R = "\ue0b4"
# Space between workspaces, on top of each one's own padding
GAP = "  "


def refresh_outputs():
    global output_x
    try:
        outs = json.loads(subprocess.check_output(["niri", "msg", "--json", "outputs"], text=True))
        output_x = {name: (o.get("logical") or {}).get("x", 0) for name, o in outs.items()}
    except (subprocess.CalledProcessError, json.JSONDecodeError, OSError):
        pass


def emit():
    parts = []
    # Group by monitor (left to right), then by index within each monitor
    # niri always keeps an empty workspace at the end of each monitor; hide it
    # (and any other unnamed empty one) unless it's the one being shown
    visible = [w for w in workspaces
               if w.get("name") or w.get("active_window_id") is not None or w.get("is_active")]
    ordered = sorted(visible, key=lambda w: (output_x.get(w.get("output"), 0), w.get("output") or "", w["idx"]))
    for i, w in enumerate(ordered):
        if i > 0 and w.get("output") != ordered[i - 1].get("output"):
            parts.append(f"<span color='{C["fg_dim"]}'>│</span>")
        idx = w.get("name") or w["idx"]
        # Unhighlighted workspaces get invisible caps so every workspace is the
        # same width (the font is proportional) and nothing shifts on focus change
        if w.get("is_urgent"):
            parts.append(f"<span color='{C["rust"]}'>{CAP_L}</span>"
                         f"<span background='{C["rust"]}' color='{C["bg"]}'> {idx} </span>"
                         f"<span color='{C["rust"]}'>{CAP_R}</span>")
        elif w.get("is_focused"):
            parts.append(f"<span color='{C["fg"]}'>{CAP_L}</span>"
                         f"<span background='{C["fg"]}' color='{C["bg"]}'><b> {idx} </b></span>"
                         f"<span color='{C["fg"]}'>{CAP_R}</span>")
        else:
            parts.append(f"<span fgalpha='1'>{CAP_L}</span>"
                         f"<span color='{C["fg_dim"]}'> {idx} </span>"
                         f"<span fgalpha='1'>{CAP_R}</span>")
    # Tabular figures keep every number the same width
    text = f"<span font_features='tnum'>{GAP.join(parts)}</span>"
    print(json.dumps({"text": text}), flush=True)


def apply_activation(ev):
    act_id = ev["id"]
    focused = ev.get("focused", True)
    act_output = next((w.get("output") for w in workspaces if w["id"] == act_id), None)
    for w in workspaces:
        if w["id"] == act_id:
            w["is_active"] = True
            if focused:
                w["is_focused"] = True
        else:
            if w.get("output") == act_output:
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
            refresh_outputs()
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
