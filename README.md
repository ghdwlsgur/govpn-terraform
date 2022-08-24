- terraform.tfvars에 변수 저장시
- tf apply --auto-approve -lock=false -var-file="terraform.tfvars"

- export
- export TF_VAR_aws_region=us-east-1
- export TF_VAR_ec2_ami=ami-0cff7528ff583bf9a
- export TF_LOG_PATH=./terraform.log
- export TF_LOG=trace

- tf apply --auto-approve -lock=false

https://www.terraform.io/cli/config/environment-variables
