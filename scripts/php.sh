#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "PHP"
echo " "

debconf-set-selections <<< 'libssl1.0.0:amd64 libssl1.0.0/restart-services string ntp'

# PHP 7.4
apt-get install -y php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-curl php7.4-dev php7.4-fpm php7.4-gd php7.4-gmp php7.4-intl \
php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-snmp php7.4-xml php7.4-zip > /dev/null 2>&1

# PHP 7.2
apt-get install -y php7.2-bcmath php7.2-bz2 php7.2-cli php7.2-curl php7.2-dev php7.2-fpm php7.2-gd php7.2-gmp php7.2-intl \
php7.2-json php7.2-ldap php7.2-mysql php7.2-opcache php7.2-readline php7.2-recode php7.2-snmp php7.2-mbstring php7.2-xml php7.2-zip > /dev/null 2>&1

# Install Generic PHP packages
apt-get install -y haveged php-apcu php-imagick php-memcache php-memcached php-redis php-ssh2 php-xdebug > /dev/null 2>&1

update-alternatives --set php /usr/bin/php7.4
update-alternatives --set php-config /usr/bin/php-config7.4
update-alternatives --set phpize /usr/bin/phpize7.4

# CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = -1/" /etc/php/7.2/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.2/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.2/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = -1/" /etc/php/7.4/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.4/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.4/cli/php.ini

# set php-fpm to run as "vagrant" user
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.2/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.2/fpm/pool.d/www.conf

sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.4/fpm/pool.d/www.conf

# error log so we can access it from outside the box
echo 'error_log = /vagrant/storage/logs/php_7.2_errors.log' >> /etc/php/7.2/fpm/php.ini
echo 'error_log = /vagrant/storage/logs/php_errors.log' >> /etc/php/7.4/fpm/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.4/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.4/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.4/mods-available/opcache.ini


sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.2/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.2/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.2/fpm/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.4/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.4/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.4/fpm/php.ini

phpdismod -s cli xdebug

#phpmyadmin
cd /srv/
wget --quiet https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
tar zxf phpMyAdmin-5.0.4-english.tar.gz
mv phpMyAdmin-5.0.4-english phpmyadmin
chown vagrant:vagrant -R phpmyadmin
cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php


# Install Composer

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
