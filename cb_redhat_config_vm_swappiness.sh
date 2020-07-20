#!/bin/bash -x

#LOG_FILE=$(basename ${0%.*})_`LANG=c date +%y%m%d_%H%M`.log
#exec > ./$LOG_FILE 2>&1

#sudo sysctl -w vm.swappiness=1

cat /proc/sys/vm/swappiness
sudo echo 0 > /proc/sys/vm/swappiness
cat /proc/sys/vm/swappiness

#sed -i.bak  /usr/lib/tuned/virtual-guest/tuned.conf -e 's/^\(vm.swappiness = .*\)/#\1\nvm.swappiness = 1/'
#grep 'vm.swappiness' /usr/lib/tuned/virtual-guest/tuned.conf

sudo echo '' >> /etc/sysctl.conf
sudo echo '# Set swappiness to 0 to avoid swapping' >> /etc/sysctl.conf
sudo echo 'vm.swappiness = 0' >> /etc/sysctl.conf