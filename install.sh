#!/bin/bash
set -e

BIN_DIR="/usr/local/bin"
CONFIG_DIR="/usr/local/bin/config"

echo "Installing scripts..."
sudo mkdir -p "$CONFIG_DIR"

for script in scripts/*.sh; do
  sudo cp "$script" "$BIN_DIR"
  sudo chmod +x "$BIN_DIR/$(basename "$script")"
done

echo "Installing config..."
sudo cp config/thresholds.conf "$CONFIG_DIR/thresholds.conf"

echo "Installation completed."

