function log {
  instanceId=$(echo 'aws_instance.linux.id' | terraform console | tr -d '"')
  instanceType=$(echo 'aws_instance.linux.instance_type' | terraform console | tr -d '"')
  instanceAZ=$(echo 'aws_instance.linux.availability_zone' | terraform console | tr -d '"')
  logName=$LOGNAME

  if [ -z "$1" ]
  then
    instanceState=$(echo 'aws_instance.linux.instance_state' | terraform console | tr -d '"')
  else
    instanceState=$1
  fi 

  timestamp=$(echo 'timestamp()' | terraform console | tr -d '"')
  echo '{}' | jq -n \
  --arg instanceId "$instanceId" \
  --arg instanceType "$instanceType" \
  --arg instanceAZ "$instanceAZ" \
  --arg instanceState "$instanceState" \
  --arg timestamp "$timestamp" \
  --arg logName "$logName" \
  '.instanceId=$instanceId|.instanceType=$instanceType|.instanceAZ=$instanceAZ|.instanceState=$instanceState|.timestamp=$timestamp|.logName=$logName' >> ./.history.log
}

log $1