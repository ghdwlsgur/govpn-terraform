module "instance" {
  source              = "../../module/instance"
  aws_region          = "ap-northeast-2"
  ec2_ami             = "ami-052f8fc3389e4b751"
  instance_type       = "t3.small"
  availability_zone   = "ap-northeast-2c"
  key_name            = aws_key_pair.govpn_key.key_name
  private_key_openssh = tls_private_key.tls.private_key_openssh
  private_key_pem     = tls_private_key.tls.private_key_pem
}


