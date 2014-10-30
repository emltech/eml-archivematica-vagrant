EML Vagrant Provisioner
=========================

##How to install
With VirtualBox, Vagrant, and Command-Line Tools (needed for git on OS X) already installed:

    git clone https://github.com/emltech/eml-archivematica-vagrant.git
    cd eml-archivematica-vagrant/
    mkdir archivematica_data/ 
    vagrant up


##What it does
Vagrantfile does the following things:  
  - Imports hashicorp/precise32 (Ubuntu 12.04 server) basebox  
  - Opens VM ports for Dashboard and Storage Service  
```Dashboard: Host port: 8080 => Guest port: 80```  
```Storage Service: Host port: 8000 => Guest port: 8000```  
  - Makes a synced directory for easy ingests  
```Host: archivematica_data Guest: /home/vagrant/archivematica_data```  
  - Calls provisioner which follows Archivematica 1.3 install instructions. Configured to avoid user input.  

To Do:  
- [ ] debconf-set-selections configuration file - from synced folder?

