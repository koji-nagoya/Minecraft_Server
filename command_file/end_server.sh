#!/bin/bash

# Display presets
STR_1="tellraw @a {\"rawtext\":[{\"text\":\"[SERVER] Reboot in "
STR_2=" sec\"}]}\\015"
STR_3=" min\"}]}\\015"

# Send a message to the Minecraft server
send_message() {
    local message=$1
    screen -S minecraft -p 0 -X stuff "$message"
}

# Countdown function
count_down() {
    echo "Starting countdown..."

    # Countdown from minutes to 1 minute
    for i in {2..2}; do
        send_message "$STR_1$i$STR_3"
        echo "Reboot in $i min..."
        sleep 1m
    done

    # Countdown from 60 to 20 seconds
    for i in 60 50 40 30 20; do
        send_message "$STR_1$i$STR_2"
        echo "Reboot in $i sec..."
        sleep 10s
    done

    # Countdown from 10 to 0 seconds
    for i in {10..0}; do
        send_message "$STR_1$i$STR_2"
        echo "Reboot in $i sec..."
        sleep 1s
    done
}

# Check if the screen session exists
if ! screen -list | grep -q "minecraft"; then
    echo "Error: No active Minecraft server found."
    exit 1
fi

# Announce server reboot
send_message 'tellraw @a {"rawtext":[{"text":"[SERVER] The server will be rebooted in 3 min"}]}\015'

# Start countdown
count_down

# Notify players about the server shutdown
send_message 'tellraw @a {"rawtext":[{"text":"[SERVER] Server is shutting down..."}]}\015'

# Stop the server
send_message 'stop\015'

echo "Server shutdown completed."

