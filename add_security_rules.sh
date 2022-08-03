#!/usr/bin/env bash 

main() {
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

	echo "Done."
}
main
