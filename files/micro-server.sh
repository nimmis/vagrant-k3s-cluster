#!/bin/sh

curl -sfL https://get.k3s.io |  INSTALL_K3S_EXEC="server --node-ip 192.168.50.10 --tls-san 192.168.50.10" sh -s -

until [  $(kubectl get nodes | grep master | grep -c Ready 2> /dev/null ) == 1 ]

sleep 10
do
  echo "Wait for kubernet to start"
  sleep 10
done
echo "Kubernet started"