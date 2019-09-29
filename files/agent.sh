#!/bin/sh
export TOKEN=$(ssh -t -o "StrictHostKeyChecking no"  -i /tmp/user-data/id_rsa vagrant@192.168.50.10 "sudo cat /var/lib/rancher/k3s/server/node-token" 2> /dev/null |
        tr -d '\r' )

echo "192.168.50.10 master" >> /etc/hosts

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.50.10:6443 --token $TOKEN" sh -s -

