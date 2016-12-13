# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  
  #nearby folder on host for novice users to appropriate folder on guest for Archivematica use.
  config.vm.synced_folder "archivematica_data", "/home/vagrant/archivematica_data"

  #good values for testing, may need more with content
  config.vm.provider "virtualbox" do |v|
     v.name = "archivematica_15_provisioner"
     v.memory = 4096
     v.cpus = 4
     v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
  end

  config.vm.post_up_message = "Hello and congrats! Your Archivematcia VM is setup. 
  If this is your first boot and you've just gone through provisioning, do the following:
  1. Reboot the VM by typing 'vagrant halt' and then 'vagrant up'
  2. Read the Archivematica installation instructions here:
     https://www.archivematica.org/wiki/Install-1.3.0-packages
     We've done everything up until the 'Test the storage service' section.
  3. Follow the Archivematica instructions on setting up the Storage Service
     available in your browser at:
     http://localhost:8000
  4. Follow the Archivematica instructions on setting up your account
     available in your browser at
     http://localhost:8080 
  5. That's it!"

  #install everything needed for archivematica
  config.vm.provision "shell", path: "archivematica_provisioner.sh"
end
