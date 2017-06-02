#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "BOOTSTRAP"
echo " "

apt-get update > /dev/null 2>&1

apt-get install -y linux-headers-$(uname -r) build-essential software-properties-common vim git curl apt-transport-https lsb-release ca-certificates > /dev/null 2>&1

# deb.sury.org
wget --quiet -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# dotDeb
add-apt-repository -y "deb http://packages.dotdeb.org jessie all"
wget --quiet https://www.dotdeb.org/dotdeb.gpg 
apt-key add dotdeb.gpg

# mariadb
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db  > /dev/null 2>&1
echo "deb [arch=amd64,i386,ppc64el] http://lon1.mirrors.digitalocean.com/mariadb/repo/10.2/debian $(lsb_release -sc) main" > /etc/apt/sources.list.d/mariadb.list

apt-get update > /dev/null 2>&1

if ! [ -L /srv/www ]; then
  rm -rf /srv/www
  ln -fs /vagrant /srv/www
fi


cat >> /home/vagrant/.bash_aliases <<EOF
alias l='ls -pla'
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias wget='wget -c'
EOF

cat /home/vagrant/.bash_aliases >> /root/.bashrc