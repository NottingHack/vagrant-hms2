#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "NODE"
echo " "

# add node
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - > /dev/null 2>&1

apt-get update > /dev/null 2>&1
apt-get install -y nodejs > /dev/null 2>&1
