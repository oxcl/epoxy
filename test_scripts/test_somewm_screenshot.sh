#!/usr/bin/env bash
# Launch somewm in headless mode, open foot, take a screenshot, and close.
# Verifies the compositor can run and capture output in headless mode.

set -euo pipefail

CONFIG="${1:-$(dirname "$0")/../config/somewm/rc.lua}"
NAME="screenshot-test-$$"
TESTDIR="$(dirname "$0")/../test_env/$$"
mkdir -p "$TESTDIR"
SCREENSHOT="$(realpath "$TESTDIR")/$(date +%Y%m%d_%H%M%S).png"

# Clean any stale instance
somewm-client test stop --name "$NAME" 2>/dev/null || true

# Start
WLR_RENDERER=pixman somewm-client test start \
    --name "$NAME" \
    --host headless \
    --config "$CONFIG"

# Launch foot terminals in the nested compositor
for i in 1 2 3 4; do
    somewm-client test run --name "$NAME" -- foot
done

# Give foot time to render
sleep 2

# Take screenshot via grim (runs inside nested compositor's Wayland session)
somewm-client test run --name "$NAME" -- grim "$SCREENSHOT"

# Wait for grim to finish
sleep 1

# Stop
somewm-client test stop --name "$NAME"

# Verify screenshot was created
if [ -f "$SCREENSHOT" ]; then
    echo "OK: $SCREENSHOT"
else
    echo "FAIL: screenshot not saved" >&2
    exit 1
fi
