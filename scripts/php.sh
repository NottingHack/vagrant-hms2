#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "PHP"
echo " "

debconf-set-selections <<< 'libssl1.0.0:amd64 libssl1.0.0/restart-services string ntp'

apt-get install -y haveged php7.1-cli php7.1-dev php7.1-fpm php7.1-mysql php7.1-apcu php7.1-json php7.1-curl php7.1-mbstring php7.1-xml php7.1-zip php7.1-xdebug php7.1-gd php7.1-memcached > /dev/null 2>&1

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.1/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.1/cli/php.ini

# set php-fpm to run as "vagrant" user
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
echo 'error_log = /vagrant/storage/logs/php_errors.log' >> /etc/php/7.1/fpm/php.ini
echo 'xdebug.remote_enable = on' >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini
echo 'xdebug.remote_connect_back = on' >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.1/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.1/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.1/fpm/php.ini

phpdismod -s cli xdebug

#phpmyadmin
cd /srv/
wget --quiet https://files.phpmyadmin.net/phpMyAdmin/4.6.4/phpMyAdmin-4.6.4-english.tar.gz
tar zxf phpMyAdmin-4.6.4-english.tar.gz 
mv phpMyAdmin-4.6.4-english phpmyadmin
chown vagrant:vagrant -R phpmyadmin
cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php


# Install Composer

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
