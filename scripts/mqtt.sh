#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MQTT"
echo " "

apt-get install -y mosquitto mosquitto-clients libmosquittopp-dev libmosquittopp1 > /dev/null 2>&1

cat <<\EOF > /etc/mosquitto/conf.d/websockets.conf
listener 1883
listener 9001
protocol websockets
websockets_headers_size 8192
EOF
