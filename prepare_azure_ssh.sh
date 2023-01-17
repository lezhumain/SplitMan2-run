#! /bin/bash

echo "$(whoami)"
TARGET_DIR="/home/$(whoami)/.ssh"
echo "TARGET_DIR: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
sudo cp "$1" "$TARGET_DIR/id_releaseUser"
sudo chmod 600 "$TARGET_DIR/id_releaseUser"
sudo chown -R "$(whoami)" "$TARGET_DIR"
