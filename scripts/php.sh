#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "PHP"
echo " "

debconf-set-selections <<< 'libssl1.0.0:amd64 libssl1.0.0/restart-services string ntp'

apt-get install -y haveged php7.2-cli php7.2-dev php7.2-fpm php7.2-mysql php7.2-apcu php7.2-json php7.2-curl php7.2-mbstring php7.2-xml php7.2-zip php7.2-xdebug php7.2-gd php7.2-memcached > /dev/null 2>&1

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = -1/" /etc/php/7.2/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.2/cli/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.2/cli/php.ini

# set php-fpm to run as "vagrant" user
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.2/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.2/fpm/pool.d/www.conf
echo 'error_log = /vagrant/storage/logs/php_errors.log' >> /etc/php/7.2/fpm/php.ini
echo 'xdebug.remote_enable = on' >> /etc/php/7.2/fpm/conf.d/20-xdebug.ini
echo 'xdebug.remote_connect_back = on' >> /etc/php/7.2/fpm/conf.d/20-xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/London/" /etc/php/7.2/fpm/php.ini
sed -i "s/;intl.default_locale =/intl.default_locale = en_GB.UTF-8/" /etc/php/7.2/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 300/" /etc/php/7.2/fpm/php.ini

phpdismod -s cli xdebug

#phpmyadmin
cd /srv/
wget --quiet https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-english.tar.gz
tar zxf phpMyAdmin-4.8.4-english.tar.gz
mv phpMyAdmin-4.8.4-english phpmyadmin
chown vagrant:vagrant -R phpmyadmin
cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php


# Install Composer

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
