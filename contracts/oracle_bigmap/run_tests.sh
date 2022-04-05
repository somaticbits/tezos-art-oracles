#!/bin/sh

echo "[*] Running tests."
echo "[*] Ligo tests."

if ligo run test ./contracts/test.mligo
then
   echo	"[*] Tests done."
else
   echo	"[*] Tests failure."
fi
