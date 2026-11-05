#!/usr/bin/env python3
"""One-shot waybar module: GitHub contributions over the past year (the number
on the profile's contribution graph), with today's count in the tooltip."""
import json
import subprocess
from datetime import date

QUERY = """
query {
  viewer {
    contributionsCollection {
      contributionCalendar {
        totalContributions
        weeks { contributionDays { date contributionCount } }
      }
    }
  }
}
"""


def main():
    try:
        out = subprocess.run(
            ["gh", "api", "graphql", "-f", f"query={QUERY}"],
            capture_output=True, text=True, timeout=20, check=True,
        ).stdout
        cal = json.loads(out)["data"]["viewer"]["contributionsCollection"]["contributionCalendar"]
    except (subprocess.SubprocessError, OSError, KeyError, ValueError):
        print(json.dumps({"text": "gh ?", "class": "error", "tooltip": "Couldn't fetch contributions"}))
        return

    today = date.today().isoformat()
    today_count = next(
        (d["contributionCount"] for w in cal["weeks"] for d in w["contributionDays"] if d["date"] == today),
        0,
    )
    total = cal["totalContributions"]
    print(json.dumps({
        "text": f"gh {total}",
        "class": "today" if today_count else "none-today",
        "tooltip": f"{total} contributions in the last year\n{today_count} today",
    }))


if __name__ == "__main__":
    main()
