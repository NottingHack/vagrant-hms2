#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "ECHO"
echo " "

# get around uWebSockets.js install issue
sudo -i su - root -c 'npm install --global @soketi/soketi'

cat >> /etc/systemd/system/soketi.service << EOF
[Unit]
Description=Soketi WebSockets
After=network.target

[Service]
User=vagrant
Group=vagrant
Environment="SOKETI_DEFAULT_APP_ID=hms"
Environment="SOKETI_DEFAULT_APP_KEY=hms-key"
Environment="SOKETI_DEFAULT_APP_SECRET=hms-secret"
Environment="SOKETI_SSL_CERT=/etc/nginx/ssl/hmsdev.crt.pem"
Environment="SOKETI_SSL_KEY=/etc/nginx/ssl/hmsdev.key.pem"
ExecStart=/usr/bin/soketi start
KillSignal=SIGINT
TimeoutStopSec=60
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable soketi.service
