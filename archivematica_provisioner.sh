sudo apt-get update
sudo apt-get install -y python-software-properties

#https://www.archivematica.org/en/docs/archivematica-1.4/admin-manual/installation/installation/#install-new
#STEP 1
sudo add-apt-repository -y ppa:archivematica/1.4

#STEP 2
sudo wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
cat << EOF | sudo tee -a /etc/apt/sources.list
deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main
EOF

#STEP 3
#Workaround for unattended GRUB upgrade. On upgrade, GRUB will ask for user input 
#for configuration which will upset the vagrant install process.
unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
ucf --purge /boot/grub/menu.lst

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy upgrade

#set installation configs early to avoid user input for mysql, mcp-server, and postfix
#Got these options after running debconf-get-selections on a successful manual install.
sudo apt-get install -y debconf-utils
cat << EOF | debconf-set-selections
mysql-server-5.0 mysql-server/root_password password sweepstakes
mysql-server-5.0 mysql-server/root_password_again password sweepstakes
mysql-server-5.0 mysql-server/root_password seen true
mysql-server-5.0 mysql-server/root_password_again seen true
archivematica-mcp-server archivematica-mcp-server/password-confirm password sweepstakes
archivematica-mcp-server archivematica-mcp-server/mysql/admin-pass password sweepstakes
archivematica-mcp-server archivematica-mcp-server/app-password-confirm password test
archivematica-mcp-server archivematica-mcp-server/db/dbname string MCP
archivematica-mcp-server archivematica-mcp-server/database-type select mysql
archivematica-mcp-server archivematica-mcp-server/mysql/method select unix socket
archivematica-mcp-server archivematica-mcp-server/internal/reconfiguring boolean false
archivematica-mcp-server archivematica-mcp-server/install-error select abort
archivematica-mcp-server archivematica-mcp-server/upgrade-error select abort
archivematica-mcp-server archivematica-mcp-server/dbconfig-install boolean true
archivematica-mcp-server archivematica-mcp-server/internal/skip-preseed boolean false
archivematica-mcp-server archivematica-mcp-server/upgrade-backup boolean true
archivematica-mcp-server archivematica-mcp-server/mysql/admin-user string root
archivematica-mcp-server archivematica-mcp-server/db/app-user string archivematica
archivematica-mcp-server archivematica-mcp-server/remove-error select abort
archivematica-mcp-server archivematica-mcp-server/dbconfig-upgrade boolean true
archivematica-mcp-server archivematica-mcp-server/missing-db-package-error select abort
archivematica-mcp-server archivematica-mcp-server/dbconfig-reinstall boolean false
postfix postfix/mailname string /etc/mailname
postfix postfix/main_mailer_type select Internet Site
postfix postfix/rfc1035_violation boolean false
postfix postfix/mynetworks string 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/mailbox_limit string 0
EOF

#STEP 4
sudo apt-get install -y archivematica-storage-service

#STEP 5
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/storage /etc/nginx/sites-enabled/storage
sudo ln -s /etc/uwsgi/apps-available/storage.ini /etc/uwsgi/apps-enabled/storage.ini
sudo service uwsgi restart
sudo service nginx restart

#STEP 6
sudo apt-get install -y archivematica-mcp-server
sudo apt-get install -y archivematica-mcp-client
sudo apt-get install -y archivematica-dashboard
sudo apt-get install -y elasticsearch

#STEP 7
sudo rm -f /etc/apache2/sites-enabled/*default*
sudo wget -q https://raw.githubusercontent.com/artefactual/archivematica/stable/1.4.x/localDevSetup/apache/apache.default -O /etc/apache2/sites-available/default.conf
sudo ln -s /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/default.conf
sudo /etc/init.d/apache2 restart
sudo freshclam
sudo /etc/init.d/clamav-daemon start
sudo /etc/init.d/elasticsearch restart
sudo /etc/init.d/gearman-job-server restart
sudo start archivematica-mcp-server
sudo start archivematica-mcp-client
sudo start fits
