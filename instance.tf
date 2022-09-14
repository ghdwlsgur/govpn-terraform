

data "template_file" "user_data" {
  template = file("./scripts/.payload.sh")
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "linux" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vpn_ec2_key.key_name
  user_data                   = data.template_file.user_data.rendered
  availability_zone           = var.availability_zone
  vpc_security_group_ids = [
    aws_security_group.vpn_security.id
  ]

  provisioner "local-exec" {
    command = <<-EOT
    terraform output -raw ssh_private_key > ~/.ssh/${aws_key_pair.vpn_ec2_key.key_name}.pem && chmod 400 ~/.ssh/${aws_key_pair.vpn_ec2_key.key_name}.pem
    if [ `terraform workspace show` == default ]; then 
      echo ${aws_instance.linux.public_dns} > ${path.module}/public_dns.txt
    else 
      echo ${aws_instance.linux.public_dns} > ${path.module}/terraform.tfstate.d/`terraform workspace show`/public_dns.txt
    fi    
    EOT     
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<-EOT
    rm -rf ~/.ssh/vpn_ec2_key.pem ./outline.json ./sg_rules.tf
    if [ `terraform workspace show` == default ]; then   
      rm -rf ${path.module}/public_dns.txt         
    else 
      rm -rf ${path.module}/terraform.tfstate.d/`terraform workspace show`/public_dns.txt          
    fi        
    EOT    
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
      private_key = tls_private_key.tls.private_key_openssh
    }
  }

  tags = {
    Name = "govpn-ec2-${var.aws_region}"
  }

}

resource "null_resource" "add_sg_rules" {
  provisioner "local-exec" {
    command = "bash ./scripts/.add_sg_rules.sh"
  }
  triggers = {
    linux = aws_instance.linux.id
  }
}

data "external" "access_key" {
  program     = ["bash", "${path.module}/scripts/.access_key.sh"]
  working_dir = path.module
  depends_on = [
    null_resource.add_sg_rules
  ]
}


