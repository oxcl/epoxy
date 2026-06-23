#!/bin/sh

CONFIG_FILE="$HOME/.config/epoxy/hypr/hyprland.lua"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config not found: $CONFIG_FILE"
  exit 1
fi

exec start-hyprland -- -c "$CONFIG_FILE"
