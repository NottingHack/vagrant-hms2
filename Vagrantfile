VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = "debian/contrib-jessie64"
  config.vm.hostname = "hmsdev.nottingtest.org.uk"

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  config.vm.network "private_network", ip: "192.168.25.35"

  config.vm.synced_folder './', '/vagrant', disabled: true

  # Run The Base Provisioning Script
  # config.vm.provision 'shell', path: './scripts/update.sh'
  # config.vm.provision :reload
  config.vm.provision 'shell', path: './scripts/bootstrap.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './scripts/nginx.sh'
  config.vm.provision 'shell', path: './scripts/database.sh'
  config.vm.provision 'shell', path: './scripts/php.sh'
  config.vm.provision 'shell', path: './scripts/kerberos.sh'
  config.vm.provision 'shell', path: './scripts/node.sh'
  config.vm.provision 'shell', path: './scripts/mailhog.sh'
  config.vm.provision 'shell', path: './scripts/redis_memcached.sh'
  config.vm.provision :reload
  # config.vm.provision 'shell', path: './scripts/laravel.sh'
  # config.vm.provision :reload
  # config.vm.provision 'shell', path: './scripts/mix.sh', privileged: false
  # config.vm.provision :reload
  config.vm.provision 'shell', path: './scripts/finish.sh'

end
 