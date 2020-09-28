#!/bin/bash +x
 
DATE=`LANG=c date +%y%m%d_%H%M`

PATH_CONFIG=~/.ssh/
FILE_CONFIG=config
OS_USER=ec2-user
#OS_USER=centos

mv ${PATH_CONFIG}${FILE_CONFIG}{,.$DATE.bak}

aws ec2 describe-instances --output=text --query 'Reservations[].Instances[].{InstanceId: InstanceId, GlobalIP: join(`, `, NetworkInterfaces[].Association.PublicIp), State: State.Name, Name: Tags[?Key==`Name`].Value|[0]}' | grep running | awk '{printf "Host %s\n  HostName %s\n  User ec2-user\n  Port 22\n  ServerAliveInterval 60\n", substr($3,match($3,"_[^_]*$")+1), $1}' > ${PATH_CONFIG}${FILE_CONFIG}
