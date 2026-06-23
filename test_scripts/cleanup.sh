#!/usr/bin/env bash
# cleanup.sh — Stop and clean up a headless Hyprland instance
#
# Usage: ./cleanup.sh [instance_id]

set -euo pipefail

INSTANCE_ID="${1:-0}"
INSTANCE_NAME="epoxy-test-${INSTANCE_ID}"
RUNTIME_DIR="/tmp/${INSTANCE_NAME}"

PID_FILE="${RUNTIME_DIR}/hyprland.pid"

if [ -f "${PID_FILE}" ]; then
  HYPRLAND_PID=$(cat "${PID_FILE}")
  if kill -0 "${HYPRLAND_PID}" 2>/dev/null; then
    echo "Stopping Hyprland instance ${INSTANCE_NAME} (PID: ${HYPRLAND_PID})" >&2
    kill "${HYPRLAND_PID}" 2>/dev/null || true
    # Wait briefly for clean exit
    sleep 0.5
  fi
  rm -f "${PID_FILE}"
fi

# Clean up runtime directory
if [ -d "${RUNTIME_DIR}" ]; then
  echo "Cleaning up ${RUNTIME_DIR}" >&2
  rm -rf "${RUNTIME_DIR}"
fi

echo "Done" >&2
