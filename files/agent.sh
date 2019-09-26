#!/bin/sh
K3S_TOKEN=$(sh -t -o "StrictHostKeyChecking no"  -i /tmp/user-data/id_rsa vagrant@192.168.50.10 "sudo cat /var/lib/rancher/k3s/server/node-token" 2> /dev/null)

echo "192.168.50.10 master" >> /etc/hosts

curl -sfL https://get.k3s.io | K3S_URL=https://master:6443 K3S_TOKEN=$K3S_TOKEN sh -