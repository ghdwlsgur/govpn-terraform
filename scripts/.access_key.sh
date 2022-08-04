#!/usr/bin/env bash 


accessKey=$(jq ".OutlineClientAccessKey" outline.json | tr -d '"')
jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
