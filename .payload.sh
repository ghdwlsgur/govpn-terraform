#!bin/bash
yum update -y
sudo yum install jq -y
sudo yum install docker -y
sudo service docker start
sudo chkconfig docker on

set -e -x
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)" > /var/log/outline-install.log

echo -e "Management UDP port number :" >> /tmp/outline-install-details.txt
cat /var/log/outline-install.log | grep "Management port" | cut -d "," -f1 | cut -d " " -f4 >> /tmp/outline-install-details.txt 
echo -e "VPN TCP / UDP port number :" >> /tmp/outline-install-details.txt
cat /var/log/outline-install.log | grep "Access key port" | cut -d "," -f1 | cut -d " " -f5 >> /tmp/outline-install-details.txt 
echo -e "Outline Client Access Key :" >> /tmp/outline-install-details.txt
sudo docker logs shadowbox | grep "accessUrl" | cut -d " " -f6 | jq '.accessUrl' | head -1 >> /tmp/outline-install-details.txt
