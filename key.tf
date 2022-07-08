
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "vpn_ec2_key" {
  key_name   = "vpn_ec2_key"
  public_key = tls_private_key.tls.public_key_openssh
}
