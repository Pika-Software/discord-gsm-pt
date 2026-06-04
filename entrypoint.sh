#!/bin/bash

# Give everything time to initialize for preventing SteamCMD deadlock
sleep 1

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

if [ -d "/home/container/.git" ]; then
    git reset --hard
    git clean -fd
    git pull
else
    git clone https://github.com/Pika-Software/discord-gsm-pt.git .
fi

pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir -r requirements.txt

mkdir -p /home/container/data/logs

# Switch to the container's working directory
cd /home/container || exit 1

# Display the command we're running in the output, and then execute it with the env
# from the container itself.
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"

# shellcheck disable=SC2086
exec env ${PARSED}
