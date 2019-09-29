#!/bin/sh

echo "PATH=\$PATH:/usr/local/bin" >> /root/.bashrc
export PATH=$PATH:/usr/local/bin

yum install -y policycoreutils-python

cp -rp /tmp/user-data/copy/* /

mkdir -p /home/vagrant/.ssh
cat /tmp/user-data/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    
/tmp/user-data/$1-centos.sh
