#!/bin/sh

echo "[*] Running tests."
echo "[*] Ligo tests."

if ligo run test ./contracts/test.mligo
then "[*] Tests done."
else "[*] Tests failure.""
