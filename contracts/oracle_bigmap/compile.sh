#!/bin/sh

ligo compile contract main.mligo -e main -o main.tz
ligo compile storage main.mligo `cat init_main_storage.mligo` -e main -o main_storage.tz
