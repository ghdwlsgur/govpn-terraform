
data "aws_security_group" "default" {
  name = "default"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "linux_security" {
  name        = "linux_security"
  description = "Allow SSH port from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
