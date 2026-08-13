#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
version=$(<"$root/VERSION")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export XDG_CACHE_HOME="$tmp/cache"
export DENO_DIR="$tmp/deno"

make_fixture() {
  local directory=$1
  mkdir -p "$directory"
  printf 'project:\n  type: default\n' > "$directory/_quarto.yml"
  cp "$root/example.qmd" "$directory/index.qmd"
}

verify_fixture() {
  local directory=$1
  test -f "$directory/_extensions/samizdata/_extension.yml"
  grep -Fqx "version: $version" "$directory/_extensions/samizdata/_extension.yml"
  test -f "$directory/_extensions/samizdata/_brand.yml"
  test -f "$directory/_extensions/samizdata/assets/logos/mark.svg"
  test -f "$directory/_extensions/samizdata/assets/logos/mark-dark.svg"

  (
    cd "$directory"
    quarto render index.qmd --quiet
  )

  local light_css dark_css
  light_css=$(find "$directory/index_files/libs/bootstrap" -name 'bootstrap-*.min.css' ! -name '*dark*' -print -quit)
  dark_css=$(find "$directory/index_files/libs/bootstrap" -name 'bootstrap-dark-*.min.css' -print -quit)
  test -n "$light_css"
  test -n "$dark_css"
  grep -Fq 'Space-Grotesk:700,900' "$light_css"
  grep -Fq 'Work-Sans:400,500' "$light_css"
  grep -Fiq '#9f1853' "$light_css"
  grep -Fiq '#c62168' "$dark_css"
  grep -Fq '_extensions/samizdata/assets/logos/mark.svg' "$directory/index.html"
  grep -Fq '_extensions/samizdata/assets/logos/mark-dark.svg' "$directory/index.html"
}

local_fixture="$tmp/local"
make_fixture "$local_fixture"
(
  cd "$local_fixture"
  quarto add "$root" --no-prompt --quiet
)
verify_fixture "$local_fixture"
printf 'consumer-owned\n' > "$local_fixture/unrelated.txt"
(
  cd "$local_fixture"
  quarto update extension "$root" --no-prompt --quiet
)
test "$(cat "$local_fixture/unrelated.txt")" = "consumer-owned"

archive="$tmp/samizdata-brand.tar.gz"
tar -C "$root" -czf "$archive" _extensions
archive_fixture="$tmp/archive"
make_fixture "$archive_fixture"
(
  cd "$archive_fixture"
  quarto add "$archive" --no-prompt --quiet
)
verify_fixture "$archive_fixture"

if (($#)); then
  remote_fixture="$tmp/remote"
  make_fixture "$remote_fixture"
  (
    cd "$remote_fixture"
    quarto add "$1" --no-prompt --quiet
  )
  verify_fixture "$remote_fixture"
  printf 'Local-directory, archive, and %s extension tests passed.\n' "$1"
else
  printf 'Local-directory and archive extension tests passed.\n'
fi
