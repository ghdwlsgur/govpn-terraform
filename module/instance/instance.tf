

data "template_file" "user_data" {
  template = file("../../scripts/payload.sh")
}

resource "aws_instance" "linux" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = data.template_file.user_data.rendered
  availability_zone           = var.availability_zone
  vpc_security_group_ids = [
    aws_security_group.govpn_security.id
  ]

  provisioner "local-exec" {
    command = "terraform output -raw ssh_private_key > ~/.ssh/${self.key_name}.pem && chmod 400 ~/.ssh/${self.key_name}.pem"
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "rm -rf ~/.ssh/${self.key_name}.pem"
    working_dir = path.module
    on_failure  = continue
  }


  root_block_device {
    volume_size = var.volume_size
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/outline.json ]; do sleep 2; done",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = var.private_key_openssh
    }
  }

  tags = {
    Name = "govpn-ec2-${var.aws_region}"
  }
}

resource "null_resource" "make_sg_rules" {
  provisioner "local-exec" {
    command = "bash ../../scripts/make_security_rules.sh ${var.aws_region} ${aws_instance.linux.public_dns} ${chomp(data.http.myip.response_body)} > /dev/null"
  }

  depends_on = [
    aws_instance.linux
  ]
}

data "external" "access_key" {
  program     = ["bash", "access_key.sh", "${var.aws_region}"]
  working_dir = "${path.module}/"

  depends_on = [
    null_resource.make_sg_rules
  ]
}



