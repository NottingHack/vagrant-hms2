#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "NGINX"
echo " "

apt-get install -y nginx-full > /dev/null 2>&1
mkdir /etc/nginx/ssl
openssl genrsa -out /etc/nginx/ssl/hmsdev.key 2048 > /dev/null 2>&1
openssl req -new -x509 -key /etc/nginx/ssl/hmsdev.key -out /etc/nginx/ssl/hmsdev.cert -days 3650 -subj /CN=hmsdev > /dev/null 2>&1

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
service nginx restart