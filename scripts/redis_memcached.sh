#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "REDIS & MEMCACHED"
echo " "

apt-get install -y redis-server memcached  > /dev/null 2>&1

sed -i 's/bind 127.0.0.1/bind 127.0.0.1 192.168.25.35/' /etc/redis/redis.conf