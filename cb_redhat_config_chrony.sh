#!/bin/bash -x

DATE=`LANG=c date +%y%m%d_%H%M`

FILE_LISTS_ALL=./server_list.txt
FILE_CHRONY_CONF=/etc/chrony.conf
FILE_CHRONY_CONF_PARTS=./server_others.txt

cat ${FILE_LISTS_ALL} | grep -v `hostname`  | awk '{printf "peer %s\n", $3}' > ${FILE_CHRONY_CONF_PARTS}

sudo yum -y update chrony

if [ -e ${FILE_CHRONY_CONF} ]; then
    sudo cat ${FILE_CHRONY_CONF_PARTS} >> ${FILE_CHRONY_CONF}
fi
sudo systemctl restart chronyd
sleep 3
sudo chronyc sourcestats -v