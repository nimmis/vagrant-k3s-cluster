# kubernetes k3 minicluster with vagrant

K3S minicluster on Alpine OS deployed with vagrant

## manage cluster from host machine

Get the kubernet config file from guest and save it in a file named k3s-confg

    ./get-config.sh <master name> > k3s-config

You can then address the k3s by adding the flag --kubeconfig=./k3s-config to the kubectl command

    kubectl --kubeconfig=./k3s-config config view

but the best way is to export a environmentvariable for kubectl so that i uses the configuration file by default

    export KUBECONFIG="$(pwd)/k3s-config"
    kubectl config view

To remove the export and let kubectl use "default" settings again

    unset KUBECONFIG

## getting kube config file from guest

    ./get-config.sh <master name> > k3s-config

## Downloading kubectl

### Linux

    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

### Mac OS

    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl

### Windows

#### with curl

    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/windows/amd64/kubectl.exe

#### with powershell

    Install-Script -Name install-kubectl -Scope CurrentUser -Force
    install-kubectl.ps1 [-DownloadLocation <path>]

## Using kubectl with k3s-config

    $> kubectl --kubeconfig=./k3s-config get nodes
    NAME     STATUS   ROLES    AGE   VERSION
    master   Ready    master   35m   v1.14.6-k3s.1

## Deploy app with ingress access

### Deploy cafe app

    kubectl apply -f examples/cafe.yaml 

### Deploy cafe.example.com certificat

    kubectl apply -f examples/cafe.example.com-secret.yaml

### Deploy cafe.example.com w/o coffee and tea

    kubectl apply -f examples/cafe_only-ingress.yaml

### test access to app

    C_PORT=8443
    C_HOST=127.0.0.1

    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/ --insecure

    Server address: 10.42.0.11:80
    Server name: cafe-77654cbdbb-qffsw
    Date: 15/Sep/2019:17:59:18 +0000
    URI: /
    Request ID: 426ebf8761a84facdb65486e9f2907b8
    
    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/coffee --insecure

### add apps for coffee and tea

    kubectl apply -f examples/coffee.yaml
    kubectl apply -f examples/tea.yaml

### deploy ingress with coffee and tea

    kubectl apply -f examples/cafe_coffee_and_tea-ingress.yaml

### check to see that url talks to different apps

    C_PORT=8443
    C_HOST=127.0.0.1

    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/ --insecure

    Server address: 10.42.0.11:80
    Server name: cafe-77654cbdbb-qffsw
    Date: 15/Sep/2019:18:01:21 +0000
    URI: /
    Request ID: 5624132df85d187692df6c51bf2cca57

    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/coffee --insecure

    Server address: 10.42.0.6:80
    Server name: coffee-bbd45c6-42mhw
    Date: 15/Sep/2019:18:02:46 +0000
    URI: /coffee
    Request ID: 585bd3ea1ad1de6dddda9b0d5f99f6a7

    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/tea --insecure

    Server address: 10.42.0.6:80
    Server name: coffee-bbd45c6-42mhw
    Date: 15/Sep/2019:18:03:16 +0000
    URI: /tea
    Request ID: 585bd3ea1ad1de6dddda9b0d5f99f6a7
    Server address: 10.42.0.6:80


### remove demo application

    kubectl delete namespace cafeexample


  