#!/usr/bin/env python3
"""Waybar module: the next open todo of the selected project, plus how many
are left. The tooltip shows that first item in full.

  todo.py          print the waybar JSON
  todo.py pick     choose the todo file in fuzzel (projects under ~/dev)
  todo.py open     open the current todo file in emacs
  todo.py update   have claude review the project and rewrite the todo file
  todo.py menu     choose one of the commands above in fuzzel
  todo.py list     every todo file as "project<TAB>hint<TAB>path" (for the palette)
  todo.py set P    make P the current todo file

The selected file is remembered in ~/.local/state/todo/current and defaults
to ~/todo.txt.

Formats understood:
  ~ section / # section       headers (shown in the tooltip, never items)
  -- item / - item / * item   items; a bare line is only an item in a .txt
                              file that uses no markers at all
  - [ ] item / - [x] item     markdown checkboxes, [x] is done
  [done] / x item             done in .txt files
Indented lines without a marker continue the item above them."""
import html
import json
import os
import re
import subprocess
import sys
import textwrap
from pathlib import Path

HOME = Path.home()
DEV = HOME / "dev"
DEFAULT = HOME / "todo.txt"
STATE = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")) / "todo/current"
SIGNAL = 10  # matches "signal" of custom/todo in the waybar config
SKIP_DIRS = {".git", "node_modules", "build", "target", "dist", ".venv", "venv", "__pycache__"}
SUFFIXES = {"", ".txt", ".md", ".org"}

CHECKBOX = re.compile(r"^(?:[-*+]|\d+[.)])\s+\[([ xX])\]\s*(.*)$")
MARKER = re.compile(r"^(?:--|[-*+]|\d+[.)])\s+(.*)$")


def current():
    try:
        p = Path(STATE.read_text().strip()).expanduser()
        if str(p):
            return p
    except (FileNotFoundError, OSError):
        pass
    return DEFAULT


def project(path):
    """~/dev/compiler/notes/todo.md -> compiler, ~/todo.txt -> home"""
    try:
        return path.relative_to(DEV).parts[0]
    except (ValueError, IndexError):
        return "home" if path == DEFAULT else path.parent.name


def parse(path):
    """-> (section, text) for every open item, in file order"""
    lines = path.read_text(errors="replace").splitlines()
    # markdown, or a txt file that marks its items (--, -, *, 1.): then lines
    # without a marker are notes, so dropping the -- from a line clears it
    md = path.suffix in (".md", ".org") or any(
        MARKER.match(l.strip()) or CHECKBOX.match(l.strip()) for l in lines)
    items, section, last_open = [], "", False
    for raw in lines:
        s = raw.strip()
        if not s:
            continue
        if s.startswith(("~", "#")):
            section, last_open = s.lstrip("~#* ").strip(), False
            continue
        if m := CHECKBOX.match(s):
            done, text = m[1] in "xX", m[2]
        elif m := MARKER.match(s):
            text = m[1]
            done = "[done]" in text.lower() or text.startswith("~~")
        elif raw[:1].isspace() and last_open and items:
            # continuation of the item above
            items[-1] = (items[-1][0], items[-1][1] + " " + s)
            continue
        elif md:
            last_open = False
            continue  # prose / notes, not an item
        else:
            text = s
            done = text.startswith("x ") or "[done]" in text.lower()
        last_open = not done
        if not done:
            items.append((section, text.strip()))
    return items


def status():
    path = current()
    name = project(path)
    e = html.escape
    try:
        items = parse(path)
    except FileNotFoundError:
        return {"text": f"{e(name)}  no todo file",
                "tooltip": f"{e(str(path))} doesn't exist yet\nclick to create it, right click for the menu",
                "class": "missing"}

    if not items:
        return {"text": f"{e(name)}  all done",
                "tooltip": f"{e(str(path))}\nnothing left", "class": "empty"}

    first = items[0][1]
    # not clipped here: waybar's label cuts it with "…" at the slot's pixel edge
    text = f"<span alpha='55%'>{e(name)} {len(items)}</span>  {e(first)}"

    tooltip = "\n".join(textwrap.wrap(first, 70))
    return {"text": text, "tooltip": e(tooltip), "class": "todos"}


def is_todo(p):
    """todo.txt, TODO, 10_todo.md, todo_173.md, or anything in a todo/ folder"""
    stem = p.stem.lower()
    return p.suffix.lower() in SUFFIXES and (
        stem.startswith("todo") or stem.endswith("todo") or p.parent.name.lower() == "todo")


def find(root, depth=3):
    """todo files under root, shallowest first"""
    found, level = [], [root]
    for _ in range(depth):
        nxt = []
        for d in level:
            try:
                entries = sorted(d.iterdir())
            except OSError:
                continue
            for p in entries:
                if p.is_dir() and not p.is_symlink():
                    if p.name not in SKIP_DIRS and not p.name.startswith("."):
                        nxt.append(p)
                elif p.is_file() and is_todo(p):
                    found.append(p)
        level = nxt
    return found


def entries():
    """(project, path, hint) for ~/todo.txt and every project under ~/dev"""
    out = [("home", DEFAULT, "~/todo.txt")] if DEFAULT.exists() else []
    for d in sorted(DEV.iterdir(), key=lambda p: p.name.lower()) if DEV.is_dir() else []:
        if not d.is_dir() or d.name.startswith("."):
            continue
        files = find(d)
        if files:
            out += [(d.name, f, str(f.relative_to(d))) for f in files]
        else:
            out.append((d.name, d / "todo.txt", "new todo.txt"))
    return out


def set_current(path):
    STATE.parent.mkdir(parents=True, exist_ok=True)
    STATE.write_text(str(path) + "\n")
    subprocess.run(["pkill", f"-RTMIN+{SIGNAL}", "-x", "waybar"])


def pick():
    entries_ = entries()
    cur = current()
    width = max(len(n) for n, _, _ in entries_) + 2
    labels = [f"{n.ljust(width)}{hint}" for n, _, hint in entries_]
    sel = next((i for i, (_, f, _) in enumerate(entries_) if f == cur), 0)
    r = subprocess.run(
        ["fuzzel", "--dmenu", "--index", "--prompt", "todo ", "--lines", "15",
         "--width", "50", f"--select-index={sel}"],
        input="\n".join(labels), capture_output=True, text=True)
    if r.returncode != 0 or not r.stdout.strip().isdigit():
        return
    set_current(entries_[int(r.stdout.strip())][1])


UPDATE_PROMPT = """Update the todo file {todo} for this project.

1. Read {todo} and keep its format exactly (headers, markers, ordering style).
2. Look at what changed: git status, git diff, and recent git log (if this is a git repo).
3. Read the code the todo items refer to and check which items are now done,
   which are stale or wrong, and look for new bugs or problems in the changed code.
4. Edit {todo}: mark finished items done (or remove them if the file doesn't
   keep done items), fix outdated items, and add new items for bugs you found.
   Put the most important next step first, since the first open item is shown
   in my status bar as what to do next.
5. Don't change any code, only {todo}. Summarise what you changed at the end."""


def root(path):
    """~/dev/compiler/notes/todo.md -> ~/dev/compiler, else the file's folder"""
    try:
        return DEV / path.relative_to(DEV).parts[0]
    except (ValueError, IndexError):
        return path.parent


def update():
    path = current()
    cwd = root(path)
    prompt = UPDATE_PROMPT.format(todo=path.relative_to(cwd))
    # +new-window hands off to the running ghostty, so cd inside the command
    os.execvp("ghostty", ["ghostty", "+new-window", "-e", "sh", "-c",
                          'cd "$1" && exec "$2" "$3"', "sh",
                          str(cwd), str(HOME / ".local/bin/claude"), prompt])


def open_current():
    os.execvp("emacsclient", ["emacsclient", "-c", "-a", "", str(current())])


COMMANDS = [
    ("open todo file", lambda: open_current()),
    ("switch project", lambda: pick()),
    ("update with claude", lambda: update()),
]


def menu():
    r = subprocess.run(
        ["fuzzel", "--dmenu", "--index", "--prompt", f"todo {project(current())} ",
         "--lines", str(len(COMMANDS)), "--width", "40"],
        input="\n".join(name for name, _ in COMMANDS), capture_output=True, text=True)
    if r.returncode == 0 and r.stdout.strip().isdigit():
        COMMANDS[int(r.stdout.strip())][1]()


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "list":
        for name, path, hint in entries():
            print(f"{name}\t{hint}\t{path}")
    elif cmd == "set" and len(sys.argv) > 2:
        set_current(Path(sys.argv[2]).expanduser())
    elif cmd == "menu":
        menu()
    elif cmd == "pick":
        pick()
    elif cmd == "update":
        update()
    elif cmd == "open":
        open_current()
    else:
        print(json.dumps(status()))
