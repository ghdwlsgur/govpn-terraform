
data "aws_security_group" "default" {
  name = "default"
}

resource "aws_security_group" "vpn_security" {
  name        = "vpn-security-group"
  description = "vpn-security-group"

  tags = {
    Name = "vpn-security-group"
  }
}


resource "aws_security_group_rule" "inbound" {
  type              = "ingress"
  description       = "Allow SSH port from only my ip"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.vpn_security.id
}
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  description       = "Allow to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn_security.id
}
