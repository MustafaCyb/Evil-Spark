#!/bin/bash

# --- Configuration ---
# IMPORTANT: Define your payload file name here. It must be in the script's directory.
PAYLOAD="your_actual_payload_file"

# Name of the PowerShell script to be moved. Must be in the script's directory.
SHELL_SCRIPT="Starter.ps1"

# Web server directory for the tools
TOOLS_DIR="/var/www/html/tools"

# --- Script Execution ---

# Must be run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please use sudo." >&2
  exit 1
fi

echo "--- Starting Apache Setup ---"

echo "[TASK 1] Updating and upgrading system packages..."
apt update -y && apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Error: Package update/upgrade failed. Exiting." >&2
    exit 1
fi

echo "[TASK 2] Installing Apache2..."
if ! dpkg -s apache2 &> /dev/null; then
    apt install -y apache2
    if [ $? -ne 0 ]; then
        echo "Error: Apache2 installation failed. Exiting." >&2
        exit 1
    fi
else
    echo "Apache2 already installed."
fi

echo "[TASK 3] Starting and enabling Apache2 service..."
systemctl start apache2
if [ $? -ne 0 ]; then
    echo "Error: Failed to start Apache2. Exiting." >&2
    exit 1
fi


echo "[TASK 4] Setting up tools directory: $TOOLS_DIR"
mkdir -p "$TOOLS_DIR" # -p creates parent dirs if needed and doesn't error if it exists
if [ $? -ne 0 ]; then
    echo "Error: Failed to create directory $TOOLS_DIR. Exiting." >&2
    exit 1
fi

# Permissions: Directory rwxr-xr-x (755)
echo "[TASK 5] Setting permissions for $TOOLS_DIR..."
chmod 755 "$TOOLS_DIR"

# Move PAYLOAD file
echo "[TASK 6] Processing PAYLOAD file: $PAYLOAD"
if [ -f "$PAYLOAD" ]; then
  mv "$PAYLOAD" "$TOOLS_DIR/"
  if [ $? -eq 0 ]; then
    chmod 644 "$TOOLS_DIR/$(basename "$PAYLOAD")" # File rw-r--r-- (644)
    echo "$PAYLOAD moved to $TOOLS_DIR."
  else
    echo "Error: Failed to move $PAYLOAD." >&2
  fi
else
  echo "Warning: PAYLOAD file '$PAYLOAD' not found. Skipping." >&2
fi

# Move SHELL_SCRIPT file
echo "[TASK 7] Processing SHELL_SCRIPT file: $SHELL_SCRIPT"
if [ -f "$SHELL_SCRIPT" ]; then
  mv "$SHELL_SCRIPT" "$TOOLS_DIR/"
  if [ $? -eq 0 ]; then
    chmod 644 "$TOOLS_DIR/$(basename "$SHELL_SCRIPT")" # File rw-r--r-- (644)
    echo "$SHELL_SCRIPT moved to $TOOLS_DIR."
  else
    echo "Error: Failed to move $SHELL_SCRIPT." >&2
  fi
else
  echo "Warning: Shell script '$SHELL_SCRIPT' not found. Skipping." >&2
fi

echo "--- Setup Script Finished ---"

# Get server's primary IP address for the access URL
SERVER_IP=$(hostname -I | awk '{print $1}')

if [ -z "$SERVER_IP" ]; then
    echo "Could not automatically determine server IP. Access files via http://localhost/tools/ if local."
else
    echo "Files (if moved successfully) should be accessible at:"
    [ -f "$TOOLS_DIR/$(basename "$PAYLOAD")" ] && echo "Payload: http://$SERVER_IP/tools/$(basename "$PAYLOAD")"
    [ -f "$TOOLS_DIR/$(basename "$SHELL_SCRIPT")" ] && echo "Shell:   http://$SERVER_IP/tools/$(basename "$SHELL_SCRIPT")"
fi
echo "Ensure firewall (e.g., ufw) allows HTTP traffic on port 80."
