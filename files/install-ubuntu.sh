#!/bin/sh

cp -rp /tmp/user-data/copy/* /

mkdir -p /home/vagrant/.ssh
cat /tmp/user-data/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    
/tmp/user-data/$1-ubuntu.sh
