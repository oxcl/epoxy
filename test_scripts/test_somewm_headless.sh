#!/usr/bin/env bash
# Launch somewm in headless mode and immediately close it.
# Verifies the compositor can start without a graphical session.

set -euo pipefail

CONFIG="${1:-$(dirname "$0")/../config/somewm/rc.lua}"
NAME="headless-test-$$"

# Clean any stale instance
somewm-client test stop --name "$NAME" 2>/dev/null || true

# Start
WLR_RENDERER=pixman somewm-client test start \
    --name "$NAME" \
    --host headless \
    --config "$CONFIG"

# Stop immediately
somewm-client test stop --name "$NAME"
echo "OK"
