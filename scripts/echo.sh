#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "ECHO"
echo " "

npm install -g laravel-echo-server

cat >> /etc/systemd/system/laravel-echo-server.service << EOF
[Unit]
Description=Start a laravel-echo-server
After=network.target

[Service]
User=vagrant
Group=vagrant
WorkingDirectory=/vagrant/
ExecStart=/usr/bin/laravel-echo-server start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
