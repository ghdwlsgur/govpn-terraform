#!/usr/bin/env bash 


region="$1"
path=$(echo ../../terraform.tfstate.d/"$region")
apiUrl=$(jq ".ApiUrl" "$path"/outline.json | sed 's/\"//g')


accessKey=$(curl --insecure -sX POST https://43.201.31.119:18823/wi42o8gCZ-nSelFl22IuNw/access-keys | jq '.accessUrl' | sed 's/\"//g')
jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 




