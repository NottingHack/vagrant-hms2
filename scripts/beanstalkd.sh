#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "BEANSTALK & SUPERVISOR"
echo " "

apt-get install -y beanstalkd supervisor  > /dev/null 2>&1
systemctl enable beanstalkd.socket

/usr/local/bin/composer create-project ptrofimov/beanstalk_console --no-progress --keep-vcs -s dev /srv/beanstalk_console

chown vagrant:vagrant -R /srv/beanstalk_console

sed -i  "s|array(/\* |array(|" /srv/beanstalk_console/config.php
sed -i  "s| \.\.\. \*/),|),|" /srv/beanstalk_console/config.php

cat <<\EOF > /etc/nginx/sites-available/beanstalk_console
server {
    listen 80;
    listen [::]:80;
    
    root /srv/beanstalk_console/public;

    index index.php;

    server_name beanstalk_console.hmsdev;

    access_log /var/log/nginx/beanstalk_console-access.log;
    error_log /var/log/nginx/beanstalk_console-error.log;

    autoindex off;
    
    # serve static files directly
    location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
        access_log off;
        expires 10d;
        add_header Cache-Control public;
    }

    # Global restrictions configuration file.
    # Designed to be included in any server {} block.</p>
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    
    # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
    # Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
    location ~ /\. {
        deny all;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    # Pass all .php files onto a php-fpm/php-fcgi server.
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
        fastcgi_read_timeout 300;
    }
}
EOF

ln -s /etc/nginx/sites-available/beanstalk_console /etc/nginx/sites-enabled/beanstalk_console

echo "127.0.0.1    beanstalk_console.hmsdev" >> /etc/hosts
