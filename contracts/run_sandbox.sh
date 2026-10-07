#!/bin/sh
# Start a local Flextesa sandbox on port 20000 (Oxford protocol, 2 s blocks).
# The last published Flextesa image is from 2023, so this is the newest protocol it offers.
set -eu
docker run --rm --name oracle-sandbox --detach -p 20000:20000 -e block_time=2 \
  oxheadalpha/flextesa:20230915 oxfordbox start
echo "Sandbox starting on http://localhost:20000 (stop with: docker stop oracle-sandbox)"
