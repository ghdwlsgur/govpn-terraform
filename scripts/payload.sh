#!/usr/bin/env bash
yum update -y
sudo yum install jq -y
sudo yum install docker -y
sudo service docker start
sudo chkconfig docker on

set -e -x
sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)" > /var/log/outline-install.log


cat > /tmp/outline.json << EOF 
{ 
  "ManagementUdpPort" : $(< /var/log/outline-install.log grep "Management port" | cut -d ',' -f1 | cut -d ' ' -f4), 
  "VpnTcpUdpPort" : $(< /var/log/outline-install.log grep 'Access key port' | cut -d ',' -f1 | cut -d ' ' -f5), 
  "ApiUrl" : "$(< /var/log/outline-install.log grep 'apiUrl' | cut -d '"' -f4)"
  "CertSha256" : "$(< /var/log/outline-install.log grep 'apiUrl' | cut -d '"' -f8)"
} 
EOF



