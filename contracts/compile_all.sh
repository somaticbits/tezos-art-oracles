#!/bin/sh
# Compile the three oracles to Michelson with a pinned LIGO in Docker, so no local LIGO install is needed.
# LIGO 0.41.0 is the newest release that compiles oracle_record_bigmap as written
# (later releases reject Map.add / Map.remove on a big_map).
set -eu

LIGO_IMAGE=ligolang/ligo:0.41.0
root=$(cd "$(dirname "$0")" && pwd)

for name in oracle_map oracle_bigmap oracle_record_bigmap; do
  echo "Compiling $name"
  dir="$root/$name/contracts"
  ligo() { docker run --rm --platform linux/amd64 -v "$dir:/src" -w /src "$LIGO_IMAGE" "$@"; }
  ligo compile contract main.mligo -e main >"$dir/main.tz"
  ligo compile storage main.mligo "$(cat "$dir/init_main_storage.mligo")" -e main >"$dir/main_storage.tz"
done
