#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MQTT"
echo " "

# cd /tmp/
# wget  https://repo.mosquitto.org/debian/pool/main/libw/libwebsockets/libwebsockets18_4.2.1-0mosquitto1~bullseye1_amd64.deb
# dpkg -i libwebsockets18_4.2.1-0mosquitto1~bullseye1_amd64.deb
# rm libwebsockets18_4.2.1-0mosquitto1~bullseye1_amd64.deb

apt-get install -y mosquitto mosquitto-clients libmosquittopp-dev libmosquittopp1 > /dev/null 2>&1

cat <<\EOF > /etc/mosquitto/conf.d/websockets.conf
allow_anonymous true
listener 1883
listener 9001
protocol websockets
websockets_headers_size 8192
EOF
