#!/usr/bin/env bash 

terraform apply --auto-approve -lock=false && bash ./scripts/.log.sh 
