#!/usr/bin/env python3
"""Waybar module: the hottest temperature sensor, with every sensor in the
tooltip. Asahi doesn't expose the CPU/GPU die sensors, so these are the SMC's
board sensors (NAND, charge regulator, wifi), the battery and the SSD.

hwmon numbers change between boots, so sensors are found by driver name."""
import json
from pathlib import Path

# Drivers to read, and a name for the ones whose sensors aren't labelled well
DRIVERS = {"macsmc_hwmon": None, "macsmc_battery": "Battery", "nvme": "SSD"}
WARNING = 55
CRITICAL = 70

sensors = []
for hwmon in Path("/sys/class/hwmon").iterdir():
    try:
        driver = (hwmon / "name").read_text().strip()
    except OSError:
        continue
    if driver not in DRIVERS:
        continue
    for temp in sorted(hwmon.glob("temp*_input")):
        label = temp.with_name(temp.name.replace("_input", "_label"))
        try:
            celsius = int(temp.read_text()) / 1000
            name = DRIVERS[driver] or label.read_text().strip()
        except (OSError, ValueError):
            continue
        sensors.append((celsius, name))

if not sensors:
    print(json.dumps({"text": "tmp ?", "tooltip": "no temperature sensors found", "class": "error"}))
    raise SystemExit

sensors.sort(reverse=True)
hottest = sensors[0][0]
cls = "critical" if hottest >= CRITICAL else "warning" if hottest >= WARNING else "normal"
tooltip = "\n".join(f"{c:.0f}°  {name}" for c, name in sensors)
print(json.dumps({"text": f"tmp {hottest:.0f}°", "tooltip": tooltip, "class": cls}))
