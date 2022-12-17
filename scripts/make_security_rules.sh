#!/usr/bin/env bash 

set -e -o pipefail


check_library() {
  echo "Checking Dependencies..."
  export jq_path=$(whereis jq | awk '{ print $2 }')
  if [ jq_path == "" ]; then 
    echo "jq IS NOT INSTALLED 🚨"
    exit 
  else 
    echo "jq IS INSTALLED ✅"
  fi 

  export rsync_path=$(whereis rsync | awk '{ print $2 }')
  if [ rsync_path == "" ]; then 
    echo "rsync IS NOT INSTALLED 🚨"
    exit 
  else 
    echo "rsync IS INSTALLED ✅"
  fi 
}

region=$(echo "$1")
public_dns=$(echo "$2")
path=$(echo ../../terraform.tfstate.d/"$region")

get_outline_info() {

  local key_pair="~/.ssh/govpn_$(echo "$region").pem"
  local ec2_hostname="ec2-user"
  local outline_file_location="/tmp/outline.json"
  
  
  rsync -avz -delete -partial -e "ssh -o StrictHostKeyChecking=no -i $key_pair" "$ec2_hostname"@"$public_dns":"$outline_file_location" "$path" > /dev/null
}


sg_id=$(echo "$3")
my_ip=$(echo "$4")

make_security_rules() {
  local get_management_port=$(jq ".ManagementUdpPort" "$path"/outline.json)
	local get_vpn_port=$(jq ".VpnTcpUdpPort" "$path"/outline.json)  
  local get_my_ip=$(echo "[\"$my_ip/32\"]")
  
cat > "$path/sg_rules.tf" <<-EOF
resource "aws_security_group_rule" "management_udp_port" {
  type              = "ingress"
  description       = "Allow Management UDP port from only my ip"
  from_port         = $get_management_port
  to_port           = $get_management_port
  protocol          = "udp"
  cidr_blocks       = $get_my_ip
  security_group_id = "$sg_id"
}
resource "aws_security_group_rule" "outline_tcp_port" {
  type              = "ingress"
  description       = "Allow Outline API TCP port from only my ip"
  from_port         = $get_management_port
  to_port           = $get_management_port
  protocol          = "tcp"
  cidr_blocks       = $get_my_ip
  security_group_id = "$sg_id"
}
resource "aws_security_group_rule" "vpn_tcp_port" {
  type              = "ingress"
  description       = "Allow TCP port from only my ip"
  from_port         = $get_vpn_port
  to_port           = $get_vpn_port
  protocol          = "tcp"
  cidr_blocks       = $get_my_ip
  security_group_id = "$sg_id"
}
resource "aws_security_group_rule" "vpn_udp_port" {
  type              = "ingress"
  description       = "Allow UDP port from only my ip"
  from_port         = $get_vpn_port
  to_port           = $get_vpn_port
  protocol          = "udp"
  cidr_blocks       = $get_my_ip
  security_group_id = "$sg_id"
}
EOF


}



main() {
  check_library && get_outline_info && make_security_rules > /dev/null && $(echo 'terraform apply --auto-approve -lock=false') > /dev/null
}
main 