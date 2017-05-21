#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " "
echo "NODE"
echo " "

# add node
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
# add yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update > /dev/null 2>&1
apt-get install -y nodejs yarn > /dev/null 2>&1

/usr/bin/npm install -g gulp
/usr/bin/npm install -g bower
/usr/bin/npm install -g grunt-cli
