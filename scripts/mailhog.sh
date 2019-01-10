#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MAILHOG"
echo " "

# Install & Configure MailHog
wget --quiet -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
chmod +x /usr/local/bin/mailhog

cat <<\EOF > /etc/systemd/system/mailhog.service
[Unit]
Description=Mailhog
After=network.target

[Service]
User=vagrant
ExecStart=/usr/bin/env /usr/local/bin/mailhog > /dev/null 2>&1 &

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable mailhog