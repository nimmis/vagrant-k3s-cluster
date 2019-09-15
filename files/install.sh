#!/bin/sh

cp -rp /tmp/user-data/copy/* /

    apk update
    apk  add -u  apk-tools
    apk add curl

    rc-update add cgroups boot
    rc-service cgroups start

    /tmp/user-data/$1.sh

