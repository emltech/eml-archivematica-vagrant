# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  
  #nearby folder on host for novice users to appropriate folder on guest for Archivematica use.
  config.vm.synced_folder "archivematica_data", "/home/vagrant/archivematica_data"

  #good values for testing, may need more with content
  config.vm.provider "virtualbox" do |v|
     v.name = "archivematica_provisioner"
     v.memory = 1024
     v.cpus = 2
     v.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
  end
  
  #install everything needed for archivematica
  config.vm.provision "shell", path: "archivematica_provisioner.sh"
end
