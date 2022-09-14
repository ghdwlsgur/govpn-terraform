#!/usr/bin/env bash 

workspace=$(echo `terraform workspace show`)
path=$(if [ $workspace == default ]; then echo .; else echo ./terraform.tfstate.d/$workspace; fi)


accessKey=$(jq ".OutlineClientAccessKey" $path/outline.json | tr -d '"' && jq ".OutlineClientAccessKey" $path/outline.json | tr -d '"' | pbcopy)
jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
