#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "NGINX"
echo " "

apt-get install -y nginx-full > /dev/null 2>&1
mkdir /etc/nginx/ssl
cp /vagrant/config/ssl/* /etc/nginx/ssl/
chmod a+r /etc/nginx/ssl/*

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

    ssl_certificate    /etc/nginx/ssl/hmsdev.crt.pem;
    ssl_certificate_key    /etc/nginx/ssl/hmsdev.key.pem;

    root /srv/www/public;

    index index.php;

    server_name hmsdev;

    access_log /vagrant/storage/logs/nginx-access.log;
    error_log /vagrant/storage/logs/nginx-error.log;

    autoindex off;

    # Enable Gzip
    gzip  on;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_min_length 1100;
    gzip_buffers     4 8k;
    gzip_proxied any;
    gzip_types
        # text/html is always compressed by HttpGzipModule
        text/css
        text/javascript
        text/xml
        text/plain
        text/x-component
        application/javascript
        application/json
        application/xml
        application/rss+xml
        font/truetype
        font/opentype
        application/vnd.ms-fontobject
        image/svg+xml;

    gzip_static on;

    gzip_proxied        expired no-cache no-store private auth;
    gzip_disable        "MSIE [1-6]\.";
    gzip_vary           on;

    # This block will catch static file requests, such as images, css, js
    # The ?: prefix is a 'non-capturing' mark, meaning we do not require
    # the pattern to be captured into $1 which should help improve performance
    location ~* \.(jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc|svg|woff|woff2|ttf)$ {
        access_log off;
        expires 10d;
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }

    # shorter cache for css and js
    location ~* \.(?:css|js)$ {
      expires 7d;
      access_log off;
      add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    }

    location ~ /.well-known {
      allow all;
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
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_read_timeout 300;
    }

    location /phpmyadmin {
        root /srv/;
        index index.php;

        location ~ ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            root /srv/;
            include /etc/nginx/fastcgi_params;
            fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
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

systemctl restart nginx.service
