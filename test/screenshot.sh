#!/usr/bin/env bash
# screenshot.sh — Capture a screenshot from a headless Hyprland instance
#
# Usage: ./screenshot.sh [instance_id] [output_file]
#   instance_id: the ID used when spawning (default: 0)
#   output_file: where to save the screenshot (default: /tmp/epoxy-test-<id>/screenshot.png)

set -euo pipefail

INSTANCE_ID="${1:-0}"
INSTANCE_NAME="epoxy-test-${INSTANCE_ID}"
RUNTIME_DIR="/tmp/${INSTANCE_NAME}"

# Default output file
OUTPUT_FILE="${2:-${RUNTIME_DIR}/screenshot.png}"

# Check if instance is running
PID_FILE="${RUNTIME_DIR}/hyprland.pid"
if [ ! -f "${PID_FILE}" ]; then
  echo "Error: No running instance found for ${INSTANCE_NAME}" >&2
  echo "Run spawn.sh first to create an instance." >&2
  exit 1
fi

HYPRLAND_PID=$(cat "${PID_FILE}")
if ! kill -0 "${HYPRLAND_PID}" 2>/dev/null; then
  echo "Error: Hyprland instance ${INSTANCE_NAME} is not running (stale PID)" >&2
  exit 1
fi

# Check for grim
if ! command -v grim &>/dev/null; then
  echo "Error: grim is not installed" >&2
  echo "Install with: nix-env -iA nixpkgs.grim" >&2
  exit 1
fi

# Capture screenshot in the isolated environment
XDG_RUNTIME_DIR="${RUNTIME_DIR}" \
WAYLAND_DISPLAY="wayland-1" \
grim "${OUTPUT_FILE}"

echo "${OUTPUT_FILE}"
