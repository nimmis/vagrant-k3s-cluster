#!/bin/sh

IP=$(vagrant ssh-config $1| grep HostName | awk '{print $2}')
PORT=$(vagrant ssh-config $1| grep Port | awk '{print $2}')
KEY=$(vagrant ssh-config $1| grep IdentityFile | awk '{print $2}')

ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null  -i $KEY -p $PORT vagrant@$IP "sudo -S cat /etc/rancher/k3s/k3s.yaml"
