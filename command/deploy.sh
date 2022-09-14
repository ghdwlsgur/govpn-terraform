#!/usr/bin/env bash 
set -e -o pipefail

craete_default_tfvars() {
    if [ ! -f ./terraform.tfvars.json ]; then
        echo "Create terraform.tfvars.json ✅"
        
cat <<EOF > "./terraform.tfvars.json"
{
    "aws_region": "ap-northeast-2",
    "ec2_ami": "ami-052f8fc3389e4b751",
    "instance_type": "t3.small",
    "availability_zone": "ap-northeast-2c"
}
EOF
    fi
}

execute() {
    terraform apply --auto-approve -lock=false -var-file="terraform.tfvars.json" && bash ./scripts/.log.sh 
}

main() {
    craete_default_tfvars && execute
}
main

