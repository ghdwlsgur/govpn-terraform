<div align="center">

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a210d5f102d142679daae01b0a8e98e0)](https://www.codacy.com/gh/ghdwlsgur/govpn-terraform/dashboard?utm_source=github.com&utm_medium=referral&utm_content=ghdwlsgur/govpn-terraform&utm_campaign=Badge_Grade)

### A repository used as a teraform module for [govpn](https://github.com/ghdwlsgur/govpn).

</div>

# How to Use

### 1. make terraform workspace

```bash
# location: govpn-terraform

terraform init
terraform workspace new us-east-1
terraform workspace select us-east-1
```

> The workspace name is the region name.

### 2. make `key.tf` file

```bash
cat > "./terraform.tfstate.d/us-east-1/key.tf" <<-EOF
resource "tls_private_key" "tls" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "govpn_key" {
    key_name = "govpn_us-east-1"
    public_key = tls_private_key.tls.public_key_openssh
}
EOF
```

### 3. make `main.tf` file

```bash
cat > "./terraform.tfstate.d/us-east-1/main.tf" <<-EOF
module "instance" {
    source = "../../module/instance"
    aws_region = "us-east-1"
    ec2_ami = "ami-0fc55bd26b303f7a8"
    instance_type = "t2.large"
    availability_zone = "us-east-1a"
    key_name = aws_key_pair.govpn_key.key_name
    private_key_openssh = tls_private_key.tls.private_key_openssh
    private_key_pem = tls_private_key.tls.private_key_pem
}
EOF
```

> choose AMI, Availability_zone, Instance Type

### 4. make `output.tf` file

```bash
cat > "./terraform.tfstate.d/us-east-1/output.tf" <<-EOF

output "ssh_private_key" {
    value = tls_private_key.tls.private_key_pem
    sensitive = true
}

output "access_key" {
    value = module.instance.OutlineClientAccessKey
}
EOF
```

### 5. make `provider.tf` file

```bash
cat > "./terraform.tfstate.d/us-east-1/provider.tf" <<-EOF
provider "aws" {
    region = "us-east-1"
}
EOF
```

### 6. terraform apply

```bash
# location: govpn-terraform/terraform.tfstate.d/us-east-1

terraform init
terraform plan
terraform apply --auto-approve -lock=false
```

### 7. terraform destroy

```bash
# location: govpn-terraform/terraform.tfstate.d/us-east-1

terraform destroy --auto-approve -lock=false
```

### 8. delete workspace

```bash
# location: govpn-terraform

terraform workspace select default
terraform woskspace delete us-east-1
```
