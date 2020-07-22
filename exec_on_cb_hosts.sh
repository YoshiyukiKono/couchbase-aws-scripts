#!/bin/sh +x

script=$1
LOG_BASE=$(basename ${1%.*})_`LANG=c date +%y%m%d_%H%M`
echo $LOG_BASE

OS_USER=ec2-user
#NODES=(CB1 CB2 CB3 CB4 CB5 CB6 CB7 CB8 CB9)
#NODES=(CB1)
NODES=(CB2 CB3 CB4 CB5 CB6 CB7 CB8 CB9)


FILE_LISTS=./server_list.txt

for node in ${NODES[@]}
do
  #echo ${LOG_BASE}_${node}.log
  scp ${FILE_LISTS} $OS_USER@$node:./
  ssh $OS_USER@$node 'LC_ALL=C sudo bash -s -x  2>&1' < $script > ${LOG_BASE}_${node}.log
done
