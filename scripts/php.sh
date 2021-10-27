#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "PHP"
echo " "

debconf-set-selections <<< 'libssl1.0.0:amd64 libssl1.0.0/restart-services string ntp'

# PHP 7.4
apt-get install -y php7.4-common php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-curl php7.4-dev php7.4-fpm php7.4-gd php7.4-gmp php7.4-intl \
php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-snmp php7.4-xml php7.4-zip \
php7.4-apcu php7.4-imagick php7.4-memcache php7.4-memcached php7.4-redis php7.4-ssh2 php7.4-xdebug > /dev/null 2>&1

# Install Generic PHP packages
apt-get install -y haveged imagemagick > /dev/null 2>&1

# CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = -1/" /etc/php/7.4/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.4/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.4/cli/php.ini

# set php-fpm to run as "vagrant" user
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.4/fpm/pool.d/www.conf

# error log so we can access it from outside the box
echo 'error_log = /vagrant/storage/logs/php_errors.log' >> /etc/php/7.4/fpm/php.ini

echo "xdebug.mode = debug" >> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.client_port = 9003">> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.4/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.4/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.4/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.4/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.4/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.4/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.4/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/7.4/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.4/fpm/php.ini


# PHP 8.0
apt-get install -y php8.0-common php8.0-bcmath php8.0-bz2 php8.0-cli php8.0-curl php8.0-dev php8.0-fpm php8.0-gd php8.0-gmp php8.0-intl \
php8.0-json php8.0-ldap php8.0-mbstring php8.0-mysql php8.0-opcache php8.0-readline php8.0-snmp php8.0-xml php8.0-zip \
php8.0-apcu php8.0-imagick php8.0-memcache php8.0-memcached php8.0-redis php8.0-ssh2 php8.0-xdebug > /dev/null 2>&1

# CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = -1/" /etc/php/8.0/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/8.0/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/8.0/cli/php.ini

# set php-fpm to run as "vagrant" user
sed -i 's/user = www-data/user = vagrant/g' /etc/php/8.0/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/8.0/fpm/pool.d/www.conf

# error log so we can access it from outside the box
echo 'error_log = /vagrant/storage/logs/php_errors.log' >> /etc/php/8.0/fpm/php.ini

echo "xdebug.mode = debug" >> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.client_port = 9003">> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.0/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.0/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/8.0/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/8.0/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/8.0/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini

update-alternatives --set php /usr/bin/php7.4
update-alternatives --set php-config /usr/bin/php-config7.4
update-alternatives --set phpize /usr/bin/phpize7.4

phpdismod -s cli xdebug

#phpmyadmin
cd /srv/
wget --quiet https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-english.tar.gz
tar zxf phpMyAdmin-5.1.1-english.tar.gz
mv phpMyAdmin-5.1.1-english phpmyadmin
chown vagrant:vagrant -R phpmyadmin
cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
