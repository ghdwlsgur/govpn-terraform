#!/usr/bin/env bash 

terraform apply --auto-approve -lock=false -var-file="terraform.tfvars" && bash ./scripts/.log.sh 
