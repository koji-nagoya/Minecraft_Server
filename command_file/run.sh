#!/bin/bash

# Check if a screen session with the name "minecraft" is already running
RUN_STATUS_MC=$(screen -ls | grep -w "minecraft" | wc -l)

if [ "$RUN_STATUS_MC" -eq 0 ]; then
    # No "minecraft" screen session found, start a new server
    echo "Starting new server..."
    cd /home/koji/minecraft/bedrock/server/ || { echo "Server directory not found."; exit 1; }
    screen -dm -S minecraft /bin/bash -c "LD_LIBRARY_PATH=. ./bedrock_server"
else
    echo -e "Server already running.\n"
fi

