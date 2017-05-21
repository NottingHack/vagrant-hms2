#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "REDIS & MEMCACHED"
echo " "

apt-get install -y redis-server memcached
