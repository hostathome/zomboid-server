#!/bin/bash
set -e

# Ensure directories exist
mkdir -p /data/configs /data/mods

# Copy default config if missing
if [ ! -f /data/configs/config.yaml ]; then
    echo "HostAtHome: No config found, using built-in defaults..."
    cp /defaults/config.yaml /data/configs/
else
    echo "HostAtHome: Using mounted configuration from /data/configs/config.yaml"
fi

# Copy default mods config if missing
if [ ! -f /data/mods/mods.yaml ]; then
    echo "HostAtHome: No mods config found, using built-in defaults..."
    cp /defaults/mods.yaml /data/mods/
else
    echo "HostAtHome: Using mounted mods configuration"
fi

echo "Installing/updating Project Zomboid..."
steamcmd +force_install_dir /server +login anonymous +app_update 380870 validate +quit

# Setup Zomboid home
mkdir -p /home/zomboid/Zomboid/Server
ln -sfn /data/save /home/zomboid/Zomboid/Saves
ln -sfn /data/mods /home/zomboid/Zomboid/mods
ln -sfn /data/data /home/zomboid/Zomboid/db

# Parse mods from mods.yaml
MODS_FILE=/data/mods/mods.yaml
WORKSHOP_IDS=$(yq '.workshop[].id // "" | select(. != "")' $MODS_FILE 2>/dev/null | tr '\n' ';' | sed 's/;$//')
MOD_NAMES=$(yq '.workshop[].name // "" | select(. != "")' $MODS_FILE 2>/dev/null | tr '\n' ';' | sed 's/;$//')

# Generate server.ini from config.yaml
CONFIG=/data/configs/config.yaml
cat > /home/zomboid/Zomboid/Server/servertest.ini << EOF
PublicName=$(yq '.server.name' $CONFIG)
PublicDescription=$(yq '.server.description' $CONFIG)
Password=$(yq '.server.password' $CONFIG)
MaxPlayers=$(yq '.server.max-players' $CONFIG)
PauseEmpty=$(yq '.gameplay.pause-empty' $CONFIG)
PVP=$(yq '.gameplay.pvp' $CONFIG)
Map=$(yq '.world.map' $CONFIG)
WorkshopItems=${WORKSHOP_IDS}
Mods=${MOD_NAMES}
DefaultPort=16261
EOF

ADMIN_PASS=$(yq '.server.admin-password' $CONFIG)
chown -R zomboid:zomboid /home/zomboid /data /server

echo "Starting Project Zomboid..."
[ -n "$WORKSHOP_IDS" ] && echo "Workshop mods: $WORKSHOP_IDS"
cd /server
exec su zomboid -c "./start-server.sh -servername servertest -adminpassword $ADMIN_PASS"
