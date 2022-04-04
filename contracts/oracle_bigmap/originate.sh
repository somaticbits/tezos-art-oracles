#!/bin/sh

ligo compile contract main.mligo -e main -o main.tz
ligo compile storage main.mligo `cat init_main_storage.mligo` -e main -o main_storage.tz
tezos-client -E https://hangzhounet.smartpy.io originate contract main transferring 1 from ligoacct running main.tz --init "`cat main_storage.tz`" --burn-cap 2 --force
