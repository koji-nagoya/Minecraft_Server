#!/bin/bash
# This is a SHELL programme to reboot the bedrock server

# Stop the bedrock server
if ! /home/koji/minecraft/bedrock/end_server.sh; then
    echo "Error: Failed to stop the server."
    exit 1
fi

# Wait until the bedrock server stops
echo "Waiting for the server to stop..."
sleep 240

# Restart the bedrock server
if ! /home/koji/minecraft/bedrock/run.sh; then
    echo "Error: Failed to start the server."
    exit 1
fi

echo "Server successfully restarted."

