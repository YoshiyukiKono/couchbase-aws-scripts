#!/bin/bash +x

#aws ec2 describe-instances --output=text --query 'Reservations[].Instances[].{InstanceId: InstanceId, PublicDnsName: PublicDnsName, State: State.Name, Name: Tags[?Key==`Name`].Value|[0]}' | grep running | awk '{printf "[\"%s\"]=\"%s\"\n", substr($2,match($2,"_[^_]*$")+1),$3}'

FILE_LISTS=./server_list.txt

aws ec2 describe-instances --output=text --query 'Reservations[].Instances[].{InstanceId: InstanceId, PublicDnsName: PrivateDnsName, State: State.Name, Name: Tags[?Key==`Name`].Value|[0], PrivateDnsName: PublicDnsName}' | grep running | awk '{printf "%s\tt%s\t%s\n", substr($2,match($2,"_[^_]*$")+1),$4,$3}' > ${FILE_LISTS}