#!/usr/bin/env bash

# install required vagrant plugin to handle reloads during provisioning
vagrant plugin install vagrant-reload

# start with no machines
vagrant destroy -f
rm -rf .vagrant*
rm virtualbox.box

time vagrant up --provider virtualbox 2>&1 | tee virtualbox-build-output.log
vagrant halt
vagrant package --base `ls ~/VirtualBox\ VMs | grep vagrant-hms2` --output virtualbox.box

ls -lh virtualbox.box
vagrant destroy -f
rm -rf .vagrant*

# force add as a local box ready for testing
if [ -f ./virtualbox.box ]; then
    vagrant box add ./virtualbox.box -f --name=hms
fi
