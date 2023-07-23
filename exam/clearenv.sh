#!/bin/bash
cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)
[ -f *.yaml ] && rm *.yaml
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

### Pod Logs (5%)
kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F1-pod-log.yaml

### Check Ready Node (4%)

[ ! -d /opt/KUSC00402/ ] && mkdir -p /opt/KUSC00402/
[ -f /opt/KUSC00402/* ] && rm /opt/KUSC00402/*
echo 'Check Ready Node clear'

### NodeSelector (4%)
kubectl label node ${cluster}-worker disk=spinning
### CPU (5%)

kubectl get pods -n kube-system |grep metrics-server
[ $? != '0' ] && kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/metrics-server.yaml

[ -d /opt/KUTR00401/ ] && rm /opt/KUTR00401/* && touch /opt/KUTR00401/KURT00401.txt
kubectl label node ${cluster}-worker2 name=cpu-loader

kubectl run cpu1 --image=quay.io/cloudwalker/sre.base --restart=Never --labels=name=cpu-loader -- stress-ng --cpu 2  --timeout 600s


### Sidecar (7%)
kubectl create -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F6-pod-sidecar.yaml

## Deployment 應用 - Scale (4%)
kubectl delete deploy presentation 2> /dev/null;
kubectl delete deploy loadbalance 2> /dev/null;

kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;
kubectl create deployment loadbalance --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;

## cordon & drain (4%)
kubectl uncordon ${cluster}-worker
kubectl uncordon ${cluster}-worker2

## Trobleshooting - kubelet 故障(2%?)
which ssh &>/dev/null
[ $? != 0 ] && apt update && apt install -y ssh
apt install sudo
echo -e \root\\nroot\\n| passwd root &>/dev/null

echo "127.0.0.1       localhost wk8s-node-0" | tee -a /etc/hosts 
echo "127.0.0.1       localhost ek8s-node-1" | tee -a /etc/hosts 

### Storage PV (7%) 沒前置
### NetworkPolicy (7%)
kubectl create namespace internal 2>/dev/null
kubectl create namespace my-app 2>/dev/null

## Service (7%)
kubectl create deployment front-end --image=quay.io/cloudwalker/nginx 2>/dev/null;


