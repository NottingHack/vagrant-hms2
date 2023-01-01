#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "BOOTSTRAP"
echo " "

apt-get update > /dev/null 2>&1

apt-get install -y linux-headers-$(uname -r) build-essential software-properties-common vim git curl apt-transport-https lsb-release ca-certificates dirmngr unzip > /dev/null 2>&1

sed -i 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
# sed -i 's/en_US.UTF-8 UTF-8/# en_US.UTF-8 UTF-8/' /etc/locale.gen
update-locale LANGUAGE='en_GB:en' > /dev/null 2>&1
debconf-set-selections <<< 'locales locales/default_environment_locale select en_GB.UTF-8'
dpkg-reconfigure --frontend=noninteractive locales  > /dev/null 2>&1
timedatectl set-timezone Europe/London

# deb.sury.org
wget --quiet -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

wget --quiet -O /etc/apt/trusted.gpg.d/nginx.gpg https://packages.sury.org/nginx/apt.gpg
echo "deb https://packages.sury.org/nginx/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx.list

# mariadb
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' >/dev/null 2>&1
echo "deb http://mirrors.coreix.net/mariadb/repo/10.6/debian $(lsb_release -sc) main" > /etc/apt/sources.list.d/mariadb.list

#mosquitto
# wget -q "http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key" -O- | sudo apt-key add - >/dev/null 2>&1
# echo "deb https://repo.mosquitto.org/debian $(lsb_release -sc) main" > /etc/apt/sources.list.d/mosquitto.list

apt-get update > /dev/null 2>&1

if ! [ -L /srv/www ]; then
  rm -rf /srv/www
  ln -fs /vagrant /srv/www
fi

update-alternatives --set editor /usr/bin/vim.basic  > /dev/null 2>&1

cat >> /home/vagrant/.bash_aliases <<EOF
alias l='ls -phla'
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias wget='wget -c'
EOF

cat >> /home/vagrant/.gitignore_global << EOF
.DS_Store
EOF

cat /home/vagrant/.bash_aliases >> /root/.bashrc

# https://stackoverflow.com/questions/65149298/composer-2-0-8-issue-package-versions-deprecated
# cat >> /usr/local/bin/unzip << EOF
# #!/bin/sh

# /usr/bin/unzip "$@"
# sleep 0.2
# EOF

# chmod +x /usr/local/bin/unzip

cat >> /etc/environment <<EOF
COMPOSER_ALLOW_SUPERUSER=1
COMPOSER_RUNTIME_ENV=virtualbox
EOF
