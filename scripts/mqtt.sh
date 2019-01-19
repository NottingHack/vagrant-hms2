#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MQTT"
echo " "

apt-get install -y mosquitto mosquitto-clients libmosquittopp-dev libmosquittopp1 > /dev/null 2>&1