#!/bin/bash -x

DATE=`LANG=c date +%y%m%d_%H%M`



#if [ ! -e ~/couchbase-server-enterprise-6.5.1-centos8.x86_64.rpm ]; then
#    sudo yum -y install wget bzip2 python3
#    wget http://packages.couchbase.com/releases/6.5.1/couchbase-server-enterprise-6.5.1-centos8.x86_64.rpm
#    sudo rpm --install couchbase-server-enterprise-6.5.1-centos8.x86_64.rpm
#fi


if [ ! -e ./couchbase-release-1.0-x86_64.rpm ]; then
    curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-x86_64.rpm
fi

sudo rpm -i ./couchbase-release-1.0-x86_64.rpm
sudo yum -y install couchbase-server

echo 'PATH="$HOME/.local/bin:$HOME/bin:$PATH:/opt/couchbase/bin"' >> .bashrc 
echo "export PATH" >> .bashrc 
echo 'MANPATH=$MANPATH:/opt/Couchbase/share/man' >> .bashrc 
echo "export MANPATH" >> .bashrc 

sudo systemctl status  couchbase-server
