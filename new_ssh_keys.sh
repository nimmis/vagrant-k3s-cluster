#!/bin/sh

echo "\n\n" | ssh-keygen -t rsa -b 4096 -C "vagrant@k3s.io" -f files/id_rsa
