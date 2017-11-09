#ARCHIVEMATICA 1.5 INSTALL


#https://www.archivematica.org/en/docs/archivematica-1.6/admin-manual/installation/installation/#install-new


#STEP 1 - Add packages.archivematica.org to list of trusted repositories
#reverting to trusty because archivematica on xenial is broken
wget -O - https://packages.archivematica.org/1.6.x/key.asc | sudo apt-key add -
cat << EOF | sudo tee -a /etc/apt/sources.list
deb [arch=amd64] http://packages.archivematica.org/1.6.x/ubuntu trusty main
deb [arch=amd64] http://packages.archivematica.org/1.6.x/ubuntu-externals trusty main
EOF

#STEP 2 - Add Elasticsearch package source
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
cat << EOF | sudo tee -a /etc/apt/sources.list
deb http://packages.elasticsearch.org/elasticsearch/1.7/debian stable main
EOF

#STEP 3 - update system
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

#set installation configs early to avoid user input for mysql, mcp-server, and postfix
#Got these options after running debconf-get-selections on a successful manual install.
sudo apt-get install -y debconf-utils

sudo debconf-set-selections << EOF
mysql-server-5.7 mysql-server/root_password password sweepstakes
mysql-server-5.7 mysql-server/root_password_again password sweepstakes
mysql-server-5.7 mysql-server/root_password seen true
mysql-server-5.7 mysql-server/root_password_again seen true
archivematica-mcp-server archivematica-mcp-server/password-confirm password sweepstakes
archivematica-mcp-server archivematica-mcp-server/app-password-confirm password sweepstakes
archivematica-mcp-server archivematica-mcp-server/mysql/app-pass password demo
archivematica-mcp-server archivematica-mcp-server/mysql/admin-pass password sweepstakes
archivematica-mcp-server archivematica-mcp-server/install-error select abort
archivematica-mcp-server archivematica-mcp-server/dbconfig-install boolean true
archivematica-mcp-server archivematica-mcp-server/internal/reconfiguring boolean false
archivematica-mcp-server archivematica-mcp-server/purge boolean false
archivematica-mcp-server archivematica-mcp-server/database-type select mysql
archivematica-mcp-server archivematica-mcp-server/db/app-user string archivematica
archivematica-mcp-server archivematica-mcp-server/db/dbname string MCP
archivematica-mcp-server archivematica-mcp-server/dbconfig-reinstall boolean	false
archivematica-mcp-server archivematica-mcp-server/upgrade-backup boolean true
archivematica-mcp-server archivematica-mcp-server/remote/host select localhost
archivematica-mcp-server archivematica-mcp-server/remove-error select abort
archivematica-mcp-server archivematica-mcp-server/mysql/method select Unix socket
archivematica-mcp-server archivematica-mcp-server/dbconfig-upgrade boolean true
archivematica-mcp-server archivematica-mcp-server/upgrade-error select abort
archivematica-mcp-server archivematica-mcp-server/mysql/admin-user string debian-sys-maint
archivematica-mcp-server archivematica-mcp-server/missing-db-package-error select abort
archivematica-mcp-server archivematica-mcp-server/internal/skip-preseed boolean false
archivematica-mcp-server archivematica-mcp-server/dbconfig-remove boolean true
archivematica-mcp-server archivematica-mcp-server/remote/newhost string
archivematica-mcp-server archivematica-mcp-server/remote/port string
postfix postfix/mailname string /etc/mailname
postfix postfix/main_mailer_type select Local only
postfix postfix/rfc1035_violation boolean false
postfix postfix/mynetworks string 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/mailbox_limit string 0
EOF

#STEP 4 > this changed from 1.5 to 1.6, install elasticsearch first now...
sudo apt-get install -y elasticsearch

#STEP 5 - install storage service
sudo apt-get install -y archivematica-storage-service

#STEP 6 - configure storage service
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/storage /etc/nginx/sites-enabled/storage

#STEP 7 - update pip
#new in 1.6 but apparently optional for Xenial. Going to skip it...
sudo wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

#STEP 8 - install archivematica packages
sudo apt-get install -y archivematica-mcp-server
sudo apt-get install -y archivematica-dashboard
sudo apt-get install -y archivematica-mcp-client


#STEP 9 - configure the dashboard
sudo ln -s /etc/nginx/sites-available/dashboard.conf /etc/nginx/sites-enabled/dashboard.conf

#Step 10 - start elasticsearch - start it automatically at boot
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10


#Step 11 - start remaining servies..
sudo freshclam
sudo service clamav-daemon start
sudo service gearman-job-server restart
sudo service archivematica-mcp-server start
sudo service archivematica-mcp-client start
sudo service archivematica-storage-service start
sudo service archivematica-dashboard start
sudo service nginx restart
sudo service fits start
