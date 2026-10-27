#!/usr/bin/env python3
"""Waybar module: the package emerge is building right now, how long it has
been at it, and how long it took last time. Prints empty text when nothing
is emerging, which hides the module.

Reads /var/log/emerge.log, so the user has to be in the portage group."""
import json
import os
import re
import subprocess
import time
from pathlib import Path

LOG = Path("/var/log/emerge.log")
# How many past builds of a package to average for the estimate
HISTORY = 3

# 1792760499:  >>> emerge (3 of 5) sys-devel/llvm-19.1.7 to /
START = re.compile(r"^(\d+):  >>> emerge \((\d+) of (\d+)\) (\S+) to ")
DONE = re.compile(r"^(\d+):  ::: completed emerge \(\d+ of \d+\) (\S+) to ")
VERSION = re.compile(r"-\d.*$")


def hidden():
    print(json.dumps({"text": "", "class": "idle"}))


def fmt(seconds):
    m = int(seconds) // 60
    return f"{m // 60}h{m % 60:02d}m" if m >= 60 else f"{m}m"


def name(atom):
    """sys-devel/llvm-19.1.7 -> sys-devel/llvm"""
    return VERSION.sub("", atom)


if subprocess.run(["pgrep", "-x", "emerge"], capture_output=True).returncode != 0:
    hidden()
    raise SystemExit

try:
    lines = LOG.read_text(errors="replace").splitlines()
except OSError:
    hidden()
    raise SystemExit

# Builds that started and haven't completed yet, from the latest run only.
# With --jobs there can be several at once.
running = {}
started = {}
durations = {}
for line in lines:
    if m := START.match(line):
        ts, n, total, atom = int(m[1]), m[2], m[3], m[4]
        if n == "1":
            running.clear()
        running[atom] = (ts, n, total)
        started[atom] = ts
    elif m := DONE.match(line):
        ts, atom = int(m[1]), m[2]
        running.pop(atom, None)
        if atom in started:
            durations.setdefault(name(atom), []).append(ts - started.pop(atom))

if not running:
    hidden()
    raise SystemExit

now = time.time()
parts, tips = [], []
for atom, (ts, n, total) in sorted(running.items(), key=lambda kv: kv[1][0]):
    pkg = name(atom).split("/")[1]
    past = durations.get(name(atom), [])[-HISTORY:]
    estimate = sum(past) / len(past) if past else None
    parts.append(f"{pkg} {fmt(now - ts)}")
    tip = f"{atom}  ({n} of {total})\nrunning {fmt(now - ts)}"
    if estimate:
        tip += f", usually takes {fmt(estimate)}"
    tips.append(tip)

ts, n, total = max(running.values(), key=lambda v: int(v[1]))
text = "emerge " + " · ".join(parts)
if total != "1":
    text += f" · {n}/{total}"
print(json.dumps({"text": text, "tooltip": "\n\n".join(tips), "class": "running"}))
