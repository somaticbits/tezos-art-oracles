#!/bin/sh

image=oxheadalpha/flextesa:latest
script=hangzbox
docker run --rm --name sandbox --detach -p 20000:20000 -e block_time=3 "$image" "$script" start
