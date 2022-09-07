
__timestamp(){
  date "+%Y%m%dT%H%M%S"
}
function log {
  instanceId=$(echo 'aws_instance.linux.id' | terraform console | tr -d '"')
  instanceType=$(echo 'aws_instance.linux.instance_type' | terraform console | tr -d '"')
  instanceAZ=$(echo 'aws_instance.linux.availability_zone' | terraform console | tr -d '"')

  if [ -z "$1" ]
  then
    instanceState=$(echo 'aws_instance.linux.instance_state' | terraform console | tr -d '"')
  else
    instanceState=$1
  fi 
  
  logName=$LOGNAME

  mkdir -m 0400 -p .history
  
  echo '{}' | jq -n \
  --arg instanceId "$instanceId" \
  --arg instanceType "$instanceType" \
  --arg instanceAZ "$instanceAZ" \
  --arg instanceState "$instanceState" \
  --arg logName "$logName" \
  '.instanceId=$instanceId|.instanceType=$instanceType|.instanceAZ=$instanceAZ|.instanceState=$instanceState|.logName=$logName' > ./.history/$(__timestamp).log
}

log $1

