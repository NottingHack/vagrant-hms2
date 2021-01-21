#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "MARIADB"
echo " "


debconf-set-selections <<< 'mariadb-server mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password root'

apt-get install -y mariadb-server > /dev/null 2>&1

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

# Need to setup the DB, etc here - set appropriate privledges
mysql -uroot -proot -e "GRANT ALL ON *.* TO 'hmsdev'@'%' IDENTIFIED BY 'hmsdev' WITH GRANT OPTION"
mysql -uroot -proot -e "GRANT ALL ON *.* TO 'hms'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION"
mysql -uroot -proot -e "CREATE USER 'travis'@'%'"
mysql -uroot -proot -e "GRANT ALL ON hms_test.* TO 'travis'@'%' WITH GRANT OPTION"
mysql -uroot -proot -e "FLUSH PRIVILEGES"
mysql -uroot -proot -e "CREATE DATABASE hms"
mysql -uroot -proot -e "CREATE DATABASE hms_test"
