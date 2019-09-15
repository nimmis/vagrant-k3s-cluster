# kubernetes k3 minicluster with vagrant

K3S minicluster on Alpine OS deployed with vagrant



# manage cluster from host machine

### getting kube config file from guest

    ./get-config.sh <master name> > k3s-config


Example of content
```apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJXRENCL3FBREFnRUNBZ0VBTUFvR0NDcUdTTTQ5QkFNQ01DTXhJVEFmQmdOVkJBTU1HR3N6Y3kxelpYSjIKWlhJdFkyRkFNVFUyT0RVMU5ETTBNakFlRncweE9UQTVNVFV4TXpNeU1qSmFGdzB5T1RBNU1USXhNek15TWpKYQpNQ014SVRBZkJnTlZCQU1NR0dzemN5MXpaWEoyWlhJdFkyRkFNVFUyT0RVMU5ETTBNakJaTUJNR0J5cUdTTTQ5CkFnRUdDQ3FHU000OUF3RUhBMElBQlB1OHJqUnZaUzgwbW5VMkNzNTZtSHdhSjdibzFkQm5nMTVuZWZ0UWtrQmYKRjRLN2pESzNWTjRydkswNE9rMVlaMWNROG9oMlY0b1hPRlVBWHZFRVRqeWpJekFoTUE0R0ExVWREd0VCL3dRRQpBd0lDcERBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUFvR0NDcUdTTTQ5QkFNQ0Ewa0FNRVlDSVFEQ1RvcDNCWHcrCjRNRlM3OEhqUm9yMFhTcjBES0lBWG82TzNLQnI5Z0t6aXdJaEFKd0Nwa25hNU5xSUNQU2V0K0ZDT1hSWVRKaksKald4L0lIZDJHb1M3Q0xtUQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://localhost:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    password: 81d25bbfce93a9bd5996fd8e8abd32f0
    username: admin
```


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


# Deply app with ingress access

## Deploy cafe app

    kubectl --kubeconfig=./k3s-config apply -f examples/cafe.yaml 

## Deploy cafe.example.com certificat 

    kubectl --kubeconfig=./k3s-config apply -f examples/cafe.example.com-secret.yaml

## Deploy cafe.example.com w/o coffee and tea

    kubectl --kubeconfig=./k3s-config apply -f examples/cafe_only-ingress.yaml

## test access to app

    C_PORT=8443
    C_HOST=127.0.0.1

    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/ --insecure

    Server address: 10.42.0.11:80
    Server name: cafe-77654cbdbb-qffsw
    Date: 15/Sep/2019:17:59:18 +0000
    URI: /
    Request ID: 426ebf8761a84facdb65486e9f2907b8
    
    curl --resolve cafe.example.com:$C_PORT:$C_HOST https://cafe.example.com:$C_PORT/coffee --insecure

## add apps for coffee and tea

    kubectl --kubeconfig=./k3s-config apply -f examples/coffee.yaml
    kubectl --kubeconfig=./k3s-config apply -f examples/tea.yaml

## deploy ingress with coffee and tea

    kubectl --kubeconfig=./k3s-config apply -f examples/cafe_coffee_and_tea-ingress.yaml

## check to see that url talks to different apps

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