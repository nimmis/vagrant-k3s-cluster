#!/bin/sh

cp -rp /tmp/user-data/copy/* /

    apk update
    apk  add -u  apk-tools
    apk add curl iptables

    rc-update add cgroups boot
    rc-service cgroups start

    rc-update add iptables
    /etc/init.d/iptables save 
    iptables -I INPUT 1 -i cni0 -s 10.42.0.0/16 -j ACCEPT
    /etc/init.d/iptables save 
    rc-service iptables start

    mkdir -p /home/vagrant/.ssh
    cat /tmp/user-data/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

    /tmp/user-data/$1.sh

