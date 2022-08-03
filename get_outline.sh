#!/usr/bin/env bash 


get_outline_info() {
  local key_pair="~/.ssh/vpn_ec2_key.pem"
  local ec2_hostname="ec2-user"
  local outline_file_location="/tmp/outline.json"
  local destination_location="./"

  scp -o StrictHostKeyChecking=no -i $key_pair $ec2_hostname@$(echo 'aws_instance.linux.public_dns' | terraform console | tr -d '"'):$outline_file_location $destination_location
}

main() {
  get_outline_info
}

main