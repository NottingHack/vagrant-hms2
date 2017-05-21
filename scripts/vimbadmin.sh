#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "ViMbAdmin"
echo " "

mkdir -p /srv/vimbadmin

mysql -uroot -proot -e "CREATE DATABASE mailserver"
mysql -uroot -proot -e "GRANT ALL ON mailserver.* TO mailserver@localhost IDENTIFIED BY 'password'"
mysql -uroot -proot -e "FLUSH PRIVILEGES"

git clone https://github.com/opensolutions/ViMbAdmin.git /srv/vimbadmin
cd /srv/vimbadmin
/usr/local/bin/composer install --no-progress --no-suggest

cp /srv/vimbadmin/public/.htaccess.dist /srv/vimbadmin/public/.htaccess
cp /srv/vimbadmin/application/configs/application.ini.dist /srv/vimbadmin/application/configs/application.ini

sed -i "s|resources.doctrine2.connection.options.dbname   = 'vimbadmin'|resources.doctrine2.connection.options.dbname   = 'mailserver'|" /srv/vimbadmin/application/configs/application.ini
sed -i "s|resources.doctrine2.connection.options.user     = 'vimbadmin'|resources.doctrine2.connection.options.user     = 'mailserver'|" /srv/vimbadmin/application/configs/application.ini
sed -i "s|resources.doctrine2.connection.options.password = 'xxx'|resources.doctrine2.connection.options.password = 'password'|" /srv/vimbadmin/application/configs/application.ini
sed -i 's/ = 2000/ = 5000/' /srv/vimbadmin/application/configs/application.ini
sed -i 's|/srv/vmail/|/var/vmail/|' /srv/vimbadmin/application/configs/application.ini
sed -i 's/ViMbAdmin Administrator/hmsdev Mail Admin/' /srv/vimbadmin/application/configs/application.ini
sed -i 's/support@example.com/hsmdev@nottinghack.org.uk/' /srv/vimbadmin/application/configs/application.ini
sed -i 's/smtp.example.com/hmsdev/' /srv/vimbadmin/application/configs/application.ini
sed -i 's/server.pop3.enabled = 1/server.pop3.enabled = 0/' /srv/vimbadmin/application/configs/application.ini
sed -i 's/smtp.%d/mail.%d/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/gpo.%d/mail.%d/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/Example Limited/Nottingham Hackspace Ltd/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/Example Support Team/Nottinghack Support Team/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/ViMbAdmin Autobot/ViMbAdmin Autobot for hmsdev/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/autobot@example.com/autobot@hmsdev/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/do-not-reply@example.com/do-not-reply@hsmdev/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/sitename = "ViMbAdmin"/sitename = "ViMbAdmin @ hsmdev"/'  /srv/vimbadmin/application/configs/application.ini
sed -i 's|"https://www.example.com/vimbadmin/"|"https://vba.hsmdev/"|'  /srv/vimbadmin/application/configs/application.ini
sed -i 's/defaults.mailbox.password_scheme = "md5.salted"/defaults.mailbox.password_scheme = "dovecot:SSHA512"/' /srv/vimbadmin/application/configs/application.ini

/srv/vimbadmin/bin/doctrine2-cli.php orm:schema-tool:create

mysql -uroot -proot mailserver -e "INSERT INTO domain (id, domain, description, max_aliases, alias_count, max_mailboxes, mailbox_count, max_quota, quota, transport, backupmx, active, homedir, maildir, uid, gid, created, modified) VALUES (1, 'nottinghack.org.uk', '', 0, 0, 0, 0, 0, 0, 'virtual', 0, 1, NULL, NULL, NULL, NULL, '2014-05-14 19:43:48', '2017-05-17 00:06:14')"


echo " "
echo "ViMbAdmin API"
echo " "

mysql -uroot -proot -e "CREATE DATABASE \`vimbadmin-api\`"
mysql -uroot -proot -e "GRANT ALL ON mailserver.* TO \`vimbadmin-api\`@localhost IDENTIFIED BY 'password'"
mysql -uroot -proot -e "GRANT ALL ON \`vimbadmin-api\`.* TO \`vimbadmin-api\`@localhost"
mysql -uroot -proot -e "FLUSH PRIVILEGES"

mkdir -p /srv/vimbadmin-api

git clone https://github.com/dpslwk/vimbadmin-api.git /srv/vimbadmin-api
cd /srv/vimbadmin-api
/usr/local/bin/composer install --no-progress --no-suggest

cat <<\EOF > /srv/vimbadmin-api/.env
APP_ENV=local
APP_DEBUG=true
APP_KEY=sbLYTUohcSWeTr13VXgu0GGjB7FIkn3u
APP_TIMEZONE=UTC

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=vimbadmin-api
DB_USERNAME=vimbadmin-api
DB_PASSWORD=password

VBA_CONNECTION=mysql
VBA_HOST=127.0.0.1
VBA_PORT=3306
VBA_DATABASE=mailserver
VBA_USERNAME=vimbadmin-api
VBA_PASSWORD=password

VBA_CONFIG_FILE=/srv/vimbadmin/application/configs/application.ini
EOF

php artisan migrate
php artisan passport:install
mysql -uroot -proot vimbadmin-api -e "INSERT INTO oauth_clients (id, user_id, name, secret, redirect, personal_access_client, password_client, revoked, created_at, updated_at) VALUES (3, NULL, 'HMS2.0', 'j1dbodPoVGufJA8q9MKLEWvIcCKL8crrLoImSF9w', 'http://hmsdev', 1, 0, 0, '2017-05-14 15:41:11', '2017-05-14 15:41:16')"

cat <<\EOF > /etc/nginx/sites-available/vimbadmin-api
server {
    listen 80;
    listen [::]:80;
    
    root /srv/vimbadmin-api/public;

    index index.php;

    server_name vimbadmin-api.hmsdev;

    access_log /var/log/nginx/vimbadmin-api-access.log;
    error_log /var/log/nginx/vimbadmin-api-error.log;

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

ln -s /etc/nginx/sites-available/vimbadmin-api /etc/nginx/sites-enabled/vimbadmin-api

chown vagrant:vagrant -R /srv/vimbadmin
chown vagrant:vagrant -R /srv/vimbadmin-api

echo "127.0.0.1    vimbadmin-api.hmsdev" >> /etc/hosts
service nginx restart
