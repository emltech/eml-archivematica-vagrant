EML Vagrant Provisioner
=========================



##How to install
With VirtualBox, Vagrant, and Command-Line Tools (needed for git on OS X) already installed:

1. ```git clone https://github.com/emltech/eml-archivematica-vagrant.git```
2. ```cd eml-archivematica-vagrant/```
3. Make folder in current directory. This will be a synced folder with the Archivematica VM: ```mkdir archivematica_data/```
4. ```vagrant up```
5. Wait a while...

To Do:  
[ ] debconf-set-selections configuration file - from synced folder?