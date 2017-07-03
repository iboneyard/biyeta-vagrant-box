# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./lal-tuktuk", "/app"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 1024
  end
  config.vm.provision "shell", privileged: false, path: "provision.sh"
end
