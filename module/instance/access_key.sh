#!/usr/bin/env bash 


region="$1"
path=$(echo ../../terraform.tfstate.d/"$region")
apiUrl=$(jq ".ApiUrl" "$path"/outline.json | sed 's/\"//g')

create_access_keys() {
  curl --insecure -X POST "$apiUrl"/access-keys
}

get_access_keys() {
  accessKey=$(curl --insecure "$apiUrl" | jq '.[]' | jq '.[0].accessUrl' | sed 's/\"//g')
}

main() {
  create_access_keys && get_access_keys && jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
}




