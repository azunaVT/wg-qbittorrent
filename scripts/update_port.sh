#!/bin/sh

echo Scheduled setting port to $1 in rTorrent @ localhost:5000 through nginx @ localhost:8888/RPC2
port=$1

timeout 300 bash -c 'while ! $(nc -z localhost 5000); do echo "Waiting for SGCI on localhost:5000 to be up..." && sleep 5; done' || false

timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8888)" != "200" ]]; do echo "Waiting for http://localhost:8888 to be up..." && sleep 5; done' || false

echo Changing port in rTorrent...

sed -i "s/network.port_range.set.*/network.port_range.set = ${port}-${port}/" /config/config.d/00-main.rc
cat /config/config.d/00-main.rc | grep port_range

s6-svc -r /run/service/svc-rtorrent

cat /scripts/voidRequest.tpl | sed "s/{{METHOD}}/network.port_range/" | curl -d @/dev/stdin localhost:8888/RPC2

#curl -fail -i http://localhost:${WEBUI_PORT}/api/v2/app/setPreferences --cookie "$SID" -d "json=%7B%22listen_port%22%3A${port}%7D"
