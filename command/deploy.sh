#!/usr/bin/env bash 
set -e -o pipefail

craete_default_tfvars() {
    if [ ! -f ./terraform.tfvars.json ]; then
        echo "Create terraform.tfvars.json ✅"
cat <<EOF > "./terraform.tfvars.json"
{
    "aws_region": "us-east-1",
    "ec2_ami": "ami-0cff7528ff583bf9a",
    "instance_type": "c4.large"
}
EOF
    fi
}

command() {
    terraform apply --auto-approve -lock=false -var-file="terraform.tfvars.json" && bash ./scripts/.log.sh 
}

main() {
    craete_default_tfvars && command 
}
main

