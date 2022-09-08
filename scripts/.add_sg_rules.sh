#!/usr/bin/env bash 
set -e -o pipefail

check_library() {
  echo "Checking Dependencies..."
  jq_path=$(whereis jq | awk '{ print $2 }')
  if [ jq_path == "" ]; then 
    echo "jq IS NOT INSTALLED 🚨"
    exit 
  else 
    echo "jq IS INSTALLED ✅"
  fi 

  rsync_path=$(whereis rsync | awk '{ print $2 }')
  if [ rsync_path == "" ]; then 
    echo "rsync IS NOT INSTALLED 🚨"
    exit 
  else 
    echo "rsync IS INSTALLED ✅"
  fi 
}


get_outline_info() {
  local key_pair="~/.ssh/vpn_ec2_key.pem"
  local ec2_hostname="ec2-user"
  local outline_file_location="/tmp/outline.json"
  local destination_location="./"

  rsync -avz -delete -partial -e "ssh -o StrictHostKeyChecking=no -i $key_pair" $ec2_hostname@$(echo 'aws_instance.linux.public_dns' | terraform console | tr -d '"'):$outline_file_location $destination_location
}

make_security_rules_tf() {
  local get_management_port=$(jq ".ManagementUdpPort" outline.json)
	local get_vpn_port=$(jq ".VpnTcpUdpPort" outline.json)
  local get_my_ip=$(echo "[\"\${chomp(data.http.myip.body)}/32\"]")

  cat <<EOF > "./sg_rules.tf"
resource "aws_security_group_rule" "management_udp_port" {
  type              = "ingress"
  description       = "Allow SSH port from only my ip"
  from_port         = $get_management_port
  to_port           = $get_management_port
  protocol          = "udp"
  cidr_blocks       = $get_my_ip
  security_group_id = aws_security_group.vpn_security.id
}

resource "aws_security_group_rule" "vpn_tcp_port" {
  type              = "ingress"
  description       = "Allow SSH port from only my ip"
  from_port         = $get_vpn_port
  to_port           = $get_vpn_port
  protocol          = "tcp"
  cidr_blocks       = $get_my_ip
  security_group_id = aws_security_group.vpn_security.id
}

resource "aws_security_group_rule" "vpn_udp_port" {
  type              = "ingress"
  description       = "Allow SSH port from only my ip"
  from_port         = $get_vpn_port
  to_port           = $get_vpn_port
  protocol          = "udp"
  cidr_blocks       = $get_my_ip
  security_group_id = aws_security_group.vpn_security.id
}
EOF
}


main() {
	check_library && get_outline_info > /dev/null && make_security_rules_tf > /dev/null && $(echo 'terraform apply --auto-approve -lock=false') > /dev/null
}
main
