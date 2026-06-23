#!/usr/bin/env bash
# spawn.sh — Launch an isolated headless Hyprland instance for testing
#
# Usage: ./spawn.sh [instance_id]
#   instance_id: unique identifier for this test instance (default: 0)
#
# Outputs environment variables needed by other test scripts.
# Source the output to use in your shell:
#   eval "$(./spawn.sh 0)"

set -euo pipefail

INSTANCE_ID="${1:-0}"
INSTANCE_NAME="epoxy-test-${INSTANCE_ID}"

# Isolated runtime directory for this instance
RUNTIME_DIR="/tmp/${INSTANCE_NAME}"
mkdir -p "${RUNTIME_DIR}"

# Wayland display name (socket will be at $RUNTIME_DIR/wayland-1)
WAYLAND_DISPLAY="wayland-1"

# Export environment for child processes
export XDG_RUNTIME_DIR="${RUNTIME_DIR}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY}"
export HYPRLAND_INSTANCE_SIGNATURE="${INSTANCE_NAME}"
export WLR_BACKENDS="headless"
export WLR_RENDERER="gles2"
export WLR_LIBINPUT_NO_DEVICES=1

# Find the epoxy config
EPOXY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="${EPOXY_DIR}/config/hypr/hyprland.lua"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "Error: Config not found: ${CONFIG_FILE}" >&2
  exit 1
fi

# Write PID file
PID_FILE="${RUNTIME_DIR}/hyprland.pid"

echo "Spawning headless Hyprland instance: ${INSTANCE_NAME}" >&2
echo "  Runtime dir:  ${RUNTIME_DIR}" >&2
echo "  Config:       ${CONFIG_FILE}" >&2

# Launch Hyprland in background
Hyprland -c "${CONFIG_FILE}" &
HYPRLAND_PID=$!
echo "${HYPRLAND_PID}" > "${PID_FILE}"

# Wait for the socket to appear (up to 5 seconds)
WAITED=0
while [ ! -e "${RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; do
  if ! kill -0 "${HYPRLAND_PID}" 2>/dev/null; then
    echo "Error: Hyprland exited unexpectedly" >&2
    exit 1
  fi
  sleep 0.1
  WAITED=$((WAITED + 1))
  if [ "${WAITED}" -ge 50 ]; then
    echo "Error: Timed out waiting for Hyprland socket" >&2
    kill "${HYPRLAND_PID}" 2>/dev/null || true
    exit 1
  fi
done

echo "Hyprland is ready (PID: ${HYPRLAND_PID})" >&2

# Output export commands for sourcing
cat <<EOF
export XDG_RUNTIME_DIR="${RUNTIME_DIR}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY}"
export HYPRLAND_INSTANCE_SIGNATURE="${INSTANCE_NAME}"
EOF
