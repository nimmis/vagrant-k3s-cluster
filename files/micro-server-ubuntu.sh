#!/bin/sh

IFACE=$(ip addr | grep :\ enp | tail -1 | awk '{print $2}' | sed 's/://')
curl -sfL https://get.k3s.io |  INSTALL_K3S_EXEC="server --flannel-iface=$IFACE --node-ip 192.168.50.10 --tls-san 192.168.50.10" sh -s -

sleep 10

until [  $(kubectl get nodes | grep master | grep -c Ready 2> /dev/null ) = 1 ]
do
  echo "Wait for kubernet to start"
  sleep 10
done
echo "Kubernet started"