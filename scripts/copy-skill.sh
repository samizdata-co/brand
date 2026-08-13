#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
destination=${1:?"usage: scripts/copy-skill.sh PATH"}
source="$root/skills/samizdata-design"

mkdir -p "$destination/references"
cp "$source/SKILL.md" "$destination/SKILL.md"
cp -L "$source/references/"* "$destination/references/"
printf 'Copied samizdata-design skill to %s\n' "$destination"
