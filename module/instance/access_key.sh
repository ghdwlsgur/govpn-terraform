#!/usr/bin/env bash 


region="$1"
path=$(echo ../../terraform.tfstate.d/"$region")

apiUrl=$(jq ".ApiUrl" "$path"/outline.json)
accessKey=$(curl --insecure -X POST "$apiUrl"/access-keys) > jq .accessUrl | sed 's/\"//g'

jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
