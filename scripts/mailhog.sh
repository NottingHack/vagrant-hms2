#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MAILHOG"
echo " "

# Install & Configure MailHog
wget --quiet -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64
chmod +x /usr/local/bin/mailhog

cat <<\EOF > /etc/systemd/system/mailhog.service
[Unit]
Description=MailHog Email Catcher
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mailhog
StandardOutput=journal
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable mailhog
