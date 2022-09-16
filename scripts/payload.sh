#!/usr/bin/env bash
yum update -y
sudo yum install jq -y
sudo yum install docker -y
sudo service docker start
sudo chkconfig docker on

set -e -x
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)" > /var/log/outline-install.log

cat > /tmp/outline.json << EOF 
{ 
  "ManagementUdpPort" : $(cat /var/log/outline-install.log | grep 'Management port' | cut -d ',' -f1 | cut -d ' ' -f4), 
  "VpnTcpUdpPort" : $(cat /var/log/outline-install.log | grep 'Access key port' | cut -d ',' -f1 | cut -d ' ' -f5), 
  "OutlineClientAccessKey" : $(sudo docker logs shadowbox | grep 'accessUrl' | cut -d ' ' -f6 | jq '.accessUrl' | head -1)
} 
EOF





