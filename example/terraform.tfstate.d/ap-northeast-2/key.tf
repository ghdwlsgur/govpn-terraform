
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "govpn_key" {
  key_name   = "govpn_${module.instance.Region}"
  public_key = tls_private_key.tls.public_key_openssh
}
