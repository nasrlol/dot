#!/usr/bin/env python3
import json
import subprocess
import sys

workspaces = []


def emit():
    parts = []
    for w in sorted(workspaces, key=lambda w: w["idx"]):
        idx = w["idx"]
        if w.get("is_urgent"):
            parts.append(f"<span background='#C84820' color='#0D1117'> {idx} </span>")
        elif w.get("is_focused"):
            parts.append(f"<span background='#C4A882' color='#0D1117'><b> {idx} </b></span>")
        else:
            parts.append(f"<span color='#8B7355'> {idx} </span>")
    print(json.dumps({"text": " ".join(parts)}), flush=True)


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
