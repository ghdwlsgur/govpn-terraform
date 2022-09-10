#!/usr/bin/env bash 
set -e -o pipefail

bash ./scripts/.log.sh stop && terraform destroy --auto-approve -var-file="terraform.tfvars.json"