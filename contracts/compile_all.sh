#!/bin/sh
# Compile and test the three oracles with a pinned LIGO in Docker, so no local LIGO install is needed.
# LIGO 0.38.1 is pinned: 0.40+ rejects the tests (Test API change) and 0.43+ rejects
# oracle_record_bigmap (Map.add / Map.remove on a big_map).
set -eu

LIGO_IMAGE=ligolang/ligo:0.38.1
root=$(cd "$(dirname "$0")" && pwd)

for name in oracle_map oracle_bigmap oracle_record_bigmap; do
  dir="$root/$name/contracts"
  ligo() { docker run --rm --platform linux/amd64 -v "$dir:/src" -w /src "$LIGO_IMAGE" "$@"; }
  echo "Compiling $name"
  ligo compile contract main.mligo -e main >"$dir/main.tz"
  ligo compile storage main.mligo "$(cat "$dir/init_main_storage.mligo")" -e main >"$dir/main_storage.tz"
  echo "Testing $name"
  ligo run test test.mligo >/dev/null
done
