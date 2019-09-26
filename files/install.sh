#!/bin/sh

cp -rp /tmp/user-data/copy/* /

    apk update
    apk  add -u  apk-tools
    apk add curl

    rc-update add cgroups boot
    rc-service cgroups start

    mkdir -p /home/vagrant/.ssh
    cat /tmp/user-data/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

    /tmp/user-data/$1.sh

