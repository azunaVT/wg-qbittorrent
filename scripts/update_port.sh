#!/bin/sh

echo WEBPORT: $WEBUI_PORT

echo Scheduled setting port to $1 in qBittorrent
port=$1

timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:${WEBUI_PORT})" != "200" ]]; do echo "Waiting for http://localhost:${WEBUI_PORT} to be up..." && sleep 5; done' || false

SID=$(curl -i http://localhost:${WEBUI_PORT}/api/v2/auth/login | grep SID | awk '{ print $2 }' | sed 's/;//' | sed 's/SID=//')
echo SID=$SID
echo Changing port in qBittorrent...
curl -fail -i http://localhost:${WEBUI_PORT}/api/v2/app/setPreferences --cookie "$SID" -d "json=%7B%22listen_port%22%3A${port}%7D"
