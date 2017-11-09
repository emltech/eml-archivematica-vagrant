# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8888
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  #nearby folder on host for novice users to appropriate folder on guest for Archivematica use.
  config.vm.synced_folder "archivematica_data/", "/archivematica_transfers", id: "archivematica-transfers",
  mount_options: ["uid=333","gid=333","dmode=777","fmode=777"]

  #good values for testing, may need more with content
  config.vm.provider "virtualbox" do |v|
     v.name = "archivematica_1.6"
     v.memory = 4096
     v.cpus = 4
     v.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
     v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.define :Archivematica_1_6 do |t|
   end

  config.vm.post_up_message = "Hello and congrats! Your Archivematcia VM is setup.
  If this is your first boot and you've just gone through provisioning, do the following:
  1. Reboot the VM by typing 'vagrant halt' and then 'vagrant up'
  2. Do the post install configuration steps here:
     https://www.archivematica.org/en/docs/archivematica-1.6/admin-manual/installation/installation/#post-install-config
  3. The Archivematica Storage Service is available at http://localhost:8000
  4. The Archivematica Dashboard is available at http://localhost:8888
  5. That's it!"

  #install everything needed for archivematica
  config.vm.provision "shell", path: "archivematica_provisioner.sh"

  #always run to make sure services start.
  config.vm.provision "shell", run: "always" do |s|
    s.inline = "sudo /etc/init.d/gearman-job-server restart"
    s.inline = "sudo service archivematica-mcp-server restart"
    s.inline = "sudo service archivematica-mcp-client restart"
    s.inline = "sudo service archivematica-storage-service restart"
    s.inline = "sudo service archivematica-dashboard restart"
    s.inline = "sudo service nginx restart"
    s.inline = "sudo service fits restart"
    s.inline = "sleep 5s"
    s.inline = "sudo freshclam"
    s.inline = "sleep 5s"
    s.inline = "sudo service clamav-daemon restart"
  end
end
