#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "NGINX"
echo " "

apt-get install -y nginx-full > /dev/null 2>&1
mkdir /etc/nginx/ssl
openssl genrsa -out /etc/nginx/ssl/hmsdev.key 2048 > /dev/null 2>&1
openssl req -new -x509 -key /etc/nginx/ssl/hmsdev.key -out /etc/nginx/ssl/hmsdev.cert -days 3650 -subj /CN=hmsdev > /dev/null 2>&1

rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

cat <<\EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    server_name hmsdev;

    return 301 https://hmsdev$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;

    ssl_certificate    /etc/nginx/ssl/hmsdev.cert;
    ssl_certificate_key    /etc/nginx/ssl/hmsdev.key;

    root /srv/www/public;

    index index.php;

    server_name hmsdev;

    access_log /vagrant/storage/logs/nginx-access.log;
    error_log /vagrant/storage/logs/nginx-error.log;

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

    location /phpmyadmin {
        root /srv/;
        index index.php;
            
        location ~ ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            root /srv/;
            include /etc/nginx/fastcgi_params;
            fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_read_timeout 300;
        }
        
        location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
            root /srv/;
        }
    }

    location /phpMyAdmin {
        rewrite ^/* /phpmyadmin last;
    }

}
EOF

service nginx restart