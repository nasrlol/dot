#!/bin/sh
# Build a suckless tool from pinned upstream + local patches + config.h.
#
#   ./build.sh <tool> [make-target...]    e.g. ./build.sh st install
#
# Each <tool>/ holds:
#   UPSTREAM     "<git-url> <tag-or-commit>"
#   local.diff   everything changed vs upstream (optional)
#   config.h     the actual configuration
#
# Sources are checked out into ${XDG_CACHE_HOME:-~/.cache}/suckless/<tool>,
# never into this repo, so no build artifacts end up in git.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
tool=${1:?usage: $0 <tool> [make-target...]}
shift
[ -f "$here/$tool/UPSTREAM" ] || { echo "unknown tool: $tool" >&2; exit 1; }

read -r url ref < "$here/$tool/UPSTREAM"
src=${XDG_CACHE_HOME:-$HOME/.cache}/suckless/$tool

if [ ! -d "$src/.git" ]; then
	git clone -q "$url" "$src"
fi
git -C "$src" fetch -q --tags origin
git -C "$src" checkout -q --force "$ref"
git -C "$src" clean -qfdx

if [ -f "$here/$tool/local.diff" ]; then
	git -C "$src" apply --whitespace=nowarn "$here/$tool/local.diff"
fi
cp "$here/$tool/config.h" "$src/config.h"
[ -f "$src/st-autocomplete" ] && chmod +x "$src/st-autocomplete"

make -C "$src" "$@"
