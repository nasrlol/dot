#!/usr/bin/env python3
"""Waybar module: battery percentage and time left, straight from the
battery's own fuel gauge (a TI bq40z651 behind Apple's SMC on Asahi).

Why not waybar's built-in battery module: it works out the percentage
itself from charge_now / charge_full, which reads a few percent below what
the gauge reports (and below the 80% the charge limit stops at), and its
time estimate didn't follow the gauge. Here:
  percentage  the gauge's `capacity`, the same number macOS shows
  time left   the gauge's `time_to_empty_now`, which it averages over the
              recent load, so it doesn't jump with every spike
  time to full worked out to the charge limit, not to 100% (the gauge's
              own time_to_full assumes 100%)

  battery.py          print the waybar JSON
  battery.py limit    toggle the charge limit between 80% and 100%
                      (100% for a trip, or to let the gauge recalibrate)
"""
import json
import subprocess
import sys
from pathlib import Path

BAT = Path("/sys/class/power_supply/macsmc-battery")
AC = Path("/sys/class/power_supply/macsmc-ac")
SIGNAL = 11  # matches "signal" of custom/battery in modules.jsonc
WARNING, CRITICAL = 25, 10
# The gauge reports 0 or 65535 minutes when it has no estimate yet
NO_ESTIMATE = (0, 65535 * 60)


def read(name, path=BAT):
    try:
        return (path / name).read_text().strip()
    except OSError:
        return None


def num(name, path=BAT):
    v = read(name, path)
    try:
        return int(v)
    except (TypeError, ValueError):
        return None


def fmt(seconds):
    m = round(seconds / 60)
    return f"{m // 60}h {m % 60:02d}m" if m >= 60 else f"{m}m"


def status():
    cap = num("capacity")
    if cap is None:
        return {"text": "?%", "tooltip": f"no battery at {BAT}", "class": "error"}

    state = read("status")  # Charging | Discharging | Not charging | Full
    online = num("online", AC) == 1
    limit = num("charge_control_end_threshold") or 100
    watts = abs(num("power1_input", BAT / "hwmon2") or 0) / 1e6
    lines = []

    if state == "Charging":
        text, cls = f"chg {cap}%", "charging"
        now, full, current = num("charge_now"), num("charge_full"), abs(num("current_now") or 0)
        if now and full and current:
            # Charging current stays near constant up to 80%, so linear is close
            left = max(full * limit / 100 - now, 0) / current * 3600
            lines.append(f"{fmt(left)} to {limit}%  ·  {watts:.1f} W in")
    elif online:
        # On AC but not charging: held at the charge limit (or full)
        text, cls = f"ac {cap}%", "plugged"
        lines.append(f"on AC, held at {limit}% (charge limit)" if limit < 100 and cap >= limit - 5
                     else "on AC")
    else:
        text = f"{cap}%"
        cls = "critical" if cap <= CRITICAL else "warning" if cap <= WARNING else "discharging"
        tte = num("time_to_empty_now")
        if tte is not None and tte not in NO_ESTIMATE:
            lines.append(f"{fmt(tte)} left  ·  {watts:.1f} W")
        elif watts > 0.5 and (energy := num("energy_now")):
            # gauge has no average yet (just unplugged): use the current draw
            lines.append(f"about {fmt(energy / 1e6 / watts * 3600)} left  ·  {watts:.1f} W")
        else:
            lines.append("estimating time left…")

    full, design = num("energy_full"), num("energy_full_design")
    if full and design:
        lines.append(f"health {full * 100 // design}%  ·  {num('cycle_count')} cycles"
                     f"  ·  {full / 1e6:.1f} of {design / 1e6:.1f} Wh")
    lines.append(f"charge limit {limit}%  (click to toggle 80/100)")
    return {"text": text, "tooltip": "\n".join(lines), "class": cls, "percentage": cap}


def toggle_limit():
    new = "100" if (num("charge_control_end_threshold") or 100) < 100 else "80"
    subprocess.run(["sudo", "-n", "tee", str(BAT / "charge_control_end_threshold")],
                   input=new, text=True, stdout=subprocess.DEVNULL, check=True)
    body = ("charges to 100% until you switch back or reboot"
            if new == "100" else "stops charging at 80%, resumes at 75%")
    subprocess.run(["notify-send", "-a", "battery", f"charge limit {new}%", body])
    subprocess.run(["pkill", f"-RTMIN+{SIGNAL}", "-x", "waybar"])


if __name__ == "__main__":
    if sys.argv[1:] == ["limit"]:
        toggle_limit()
    else:
        print(json.dumps(status()))
