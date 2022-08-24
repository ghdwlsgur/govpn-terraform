- terraform.tfvars에 변수 저장시
- tf apply --auto-approve -lock=false -var-file="terraform.tfvars"

- export
- export TF_VAR_aws_region=us-east-1
- export TF_VAR_ec2_ami=ami-0cff7528ff583bf9a
- tf apply --auto-approve -lock=false
