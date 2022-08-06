#!/usr/bin/env bash 


accessKey=$(jq ".OutlineClientAccessKey" outline.json | tr -d '"' && jq ".OutlineClientAccessKey" outline.json | tr -d '"' | pbcopy)
jq -n --arg accessKey "$accessKey" '{"accessKey": $accessKey}' 
