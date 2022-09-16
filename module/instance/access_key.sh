#!/usr/bin/env bash 


region=$1
path=`echo ../../terraform.tfstate.d/$region`


accessKey=$(jq ".OutlineClientAccessKey" $path/outline.json | tr -d '"' && jq ".OutlineClientAccessKey" $path/outline.json | tr -d '"' | pbcopy)
jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
