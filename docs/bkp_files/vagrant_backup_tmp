# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vm.provision "shell", path: "./config_files/basic_deploy.sh"

  # Kubernetes Master Node
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/focal64"
    master.vm.hostname = "master.lab.tech"
    master.vm.network "private_network", ip: "10.50.50.100"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "master"
      vb.memory = "2048"
      vb.cpus = "4"
      vb.customize ["modifyvm", :id, "--groups", "/kubernetes"]
    end
    master.vm.provision "shell", path: "./config_files/init_master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "ubuntu/focal64"
      node.vm.hostname = "node#{i}.lab.tech"
      node.vm.network "private_network", ip: "10.50.50.10#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "node-#{i}"
        vb.memory = "2048"
        vb.cpus = "4"
        vb.customize ["modifyvm", :id, "--groups", "/kubernetes"]
      end
      node.vm.provision "shell", path: "./config_files/init_workers.sh"
    end
  end

end
