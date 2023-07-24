#!/bin/bash
source /etc/profile
cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)
grep -x "alias k='kubectl'" /etc/profile >/dev/null
[[ $? != 0 ]] && echo "
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl delete'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments' " | tee -a /etc/profile


rm *.yaml &>/dev/null
echo 'remove all yaml' 
### Pod Logs (5%)
[ ! -d /opt/KUTR00101 ] && mkdir -p /opt/KUTR00101
[ -f /opt/KUTR00101/bar ] && rm /opt/KUTR00101/*
echo 'Pod Logs clear'

kubectl get pod | tail -n +2 | cut -d ' ' -f 1 > rmpod.tmp

while read pod
do
  kubectl delete pod ${pod}

done < rmpod.tmp
rm rmpod.tmp

## Trobleshooting - kubelet 故障(2%?)
which ssh sshd &>/dev/null
[[ $? != 0 ]] && apt update && apt install -y ssh
which sudo &>/dev/null
[[ $? != 0 ]] && apt install sudo
grep -x '#PermitRootLogin yes' /etc/ssh/sshd_config && echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config
systemctl restart ssh
grep wk8s-node-0 /etc/hosts &>/dev/null
[ $? != 0 ] && echo "127.0.0.1       localhost wk8s-node-0" | tee -a /etc/hosts 
grep ek8s-node-1 /etc/hosts &>/dev/null
[ $? != 0 ] && echo "172.18.0.3       localhost ek8s-node-1" | tee -a /etc/hosts 
echo -e \root\\nroot\\n| passwd root &>/dev/null
systemctl stop kubelet

### Pod Logs (5%)
kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F1-pod-log.yaml

### Check Ready Node (4%)

[ ! -d /opt/KUSC00402/ ] && mkdir -p /opt/KUSC00402/
[ -f /opt/KUSC00402/* ] && rm /opt/KUSC00402/*
echo 'Check Ready Node clear'

### NodeSelector (4%)
kubectl label node ${cluster}-worker disk=spinning
### CPU (5%)
[ -f /opt/KUTR00401/* ] && rm /opt/KUTR00401/*
[ ! -d /opt/KUTR00401/ ] && mkdir -p /opt/KUSC00401/


kubectl get pods -n kube-system |grep metrics-server
[ $? != '0' ] && kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/metrics-server.yaml

[ -d /opt/KUTR00401/ ] && rm /opt/KUTR00401/* && touch /opt/KUTR00401/KURT00401.txt
kubectl label node ${cluster}-worker2 name=cpu-loader

kubectl run cpu1 --image=quay.io/cloudwalker/sre.base --restart=Never --labels=name=cpu-loader -- stress-ng --cpu 2  --timeout 2400s


### Sidecar (7%)
kubectl create -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F6-pod-sidecar.yaml

## Deployment 應用 - Scale (4%)
kubectl delete deploy presentation 2> /dev/null;
kubectl delete deploy loadbalancer 2> /dev/null;

kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;
kubectl create deployment loadbalancer --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;

## cordon & drain (4%)

kubectl uncordon ${cluster}-worker
kubectl uncordon ${cluster}-worker2

### Storage PV (7%) 沒前置
### NetworkPolicy (7%)
kubectl create namespace internal 2>/dev/null
kubectl create namespace my-app 2>/dev/null

### 1. NetworkPolicy (7%)
kubectl create namespace internal 2>/dev/null;
### 2. NetworkPolicy (7%)
kubectl create namespace my-app 2>/dev/null;
kubectl create namespace echo 2>/dev/null;

## Service (7%)
kubectl delete deploy front-end 2>/dev/null;
kubectl delete svc front-end-svc 2>/dev/null;
kubectl create deployment front-end --image=quay.io/cloudwalker/nginx 2>/dev/null;
### RBAC (Role-based Access Control) (4%) 
kubectl delete ns app-team1 2>/dev/null;
kubectl create ns app-team1

clear
