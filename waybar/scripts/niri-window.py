#!/usr/bin/env python3
import html
import json
import subprocess
import sys

windows = {}
focused_id = None

MAX_LEN = 60


def emit():
    w = windows.get(focused_id)
    title = (w.get("title") or w.get("app_id") or "").strip() if w else ""
    full = title
    if len(title) > MAX_LEN:
        title = title[: MAX_LEN - 1] + "…"
    print(
        json.dumps({"text": html.escape(title), "tooltip": html.escape(full)}),
        flush=True,
    )


def main():
    global windows, focused_id
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

        if "WindowsChanged" in ev:
            windows = {w["id"]: w for w in ev["WindowsChanged"]["windows"]}
            focused_id = next(
                (w["id"] for w in windows.values() if w.get("is_focused")), None
            )
            emit()
        elif "WindowOpenedOrChanged" in ev:
            w = ev["WindowOpenedOrChanged"]["window"]
            windows[w["id"]] = w
            if w.get("is_focused"):
                focused_id = w["id"]
            emit()
        elif "WindowClosed" in ev:
            wid = ev["WindowClosed"]["id"]
            windows.pop(wid, None)
            if focused_id == wid:
                focused_id = None
            emit()
        elif "WindowFocusChanged" in ev:
            focused_id = ev["WindowFocusChanged"].get("id")
            emit()


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        sys.exit(0)
