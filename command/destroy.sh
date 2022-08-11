#!/usr/bin/env bash 

bash ./scripts/.log.sh stop && terraform destroy --auto-approve -var-file="terraform.tfvars"