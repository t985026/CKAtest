#!/bin/bash

cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)
grep -x "alias k='kubectl'" /root/.bashrc >/dev/null
[[ $? != 0 ]] && echo "
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl delete'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias ka='kubectl apply'
alias kc='kubectl create'
alias cls='clear' 
alias ll='ls -alh'"| tee -a /root/.bashrc
source /root/.bashrc
echo 'remove all yaml' 
rm *.yaml &>/dev/null

kubectl delete pod web-server-volume --force &> /dev/null;
kubectl delete pod big-corp-app --force &> /dev/null;
kubectl delete web-server --force  2>/dev/null

## Deployment - Scale (4%) 前置
echo "=== clean Deployment - Scale ==="
kubectl delete deploy presentation 2> /dev/null;
kubectl delete deploy loadbalancer 2> /dev/null;
echo "=== clean Deployment - Scale done ==="

## Service (7%)
echo "=== clean Service ==="
kubectl delete deploy front-end 2>/dev/null;
kubectl delete svc front-end-svc 2>/dev/null;
echo "=== clean Service done ==="

### Storage PV (7%) 沒前置
echo "=== clean Storage PVC ==="
kubectl delete pvc --all
kubectl delete -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/pvc-pv-volume --force 2>/dev/null
echo "=== clean Storage PVC done ==="

kubectl get pod | tail -n +2 | cut -d ' ' -f 1 > rmpod.tmp
while read pod
do
  kubectl delete pod "${pod}"

done < rmpod.tmp
rm rmpod.tmp
echo "=== clean Pod Logs done ==="

## Trobleshooting - kubelet 故障(2%?)
echo "=== clean Trobleshooting - kubelet ==="
which ssh sshd &>/dev/null
[[ $? != 0 ]] && apt update && apt install -y ssh
which sudo &>/dev/null
[[ $? != 0 ]] && apt install sudo
grep -x '#PermitRootLogin yes' /etc/ssh/sshd_config && echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config
systemctl restart ssh
grep wk8s-node-0 /etc/hosts &>/dev/null
[ $? != 0 ] && echo "127.0.0.1       localhost wk8s-node-0" | tee -a /etc/hosts 
grep ek8s-node-1 /etc/hosts &>/dev/null
[ $? != 0 ] && echo "127.0.0.1        localhost ek8s-node-1" | tee -a /etc/hosts 
echo -e \root\\nroot\\n| passwd root &>/dev/null
systemctl stop kubelet
echo "=== clean Trobleshooting - kubelet done ==="


### Pod Logs (5%)
echo "=== clean Pod Logs ==="
[ ! -d /opt/KUTR00101 ] && mkdir -p /opt/KUTR00101
[ -f /opt/KUTR00101/bar ] && rm /opt/KUTR00101/*
echo 'Pod Logs clear'
kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F1-pod-log.yaml
echo "=== clean Pod Logs done ==="


### Check Ready Node (4%)
echo "=== clean Check Ready Node ==="
[ ! -d /opt/KUSC00402/ ] && mkdir -p /opt/KUSC00402/
[ -f /opt/KUSC00402/* ] && rm /opt/KUSC00402/*
echo 'Check Ready Node clear'
echo "=== clean Check Ready Node done ==="

### NodeSelector (4%)
echo "=== clean NodeSelector ==="
kubectl label node ${cluster}-worker disk=spinning
### CPU (5%)
[ -f /opt/KUTR00401/* ] && rm /opt/KUTR00401/*
[ ! -d /opt/KUTR00401/ ] && mkdir -p /opt/KUSC00401/


kubectl get pods -n kube-system |grep metrics-server
[ $? != '0' ] && kubectl apply -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/metrics-server.yaml

[ -d /opt/KUTR00401/ ] && rm /opt/KUTR00401/* && touch /opt/KUTR00401/KURT00401.txt
kubectl label node ${cluster}-worker2 name=cpu-loader

kubectl run cpu1 --image=quay.io/cloudwalker/sre.base --restart=Never --labels=name=cpu-loader -- stress-ng --cpu 2  --timeout 2400s
echo "=== clean NodeSelector done ==="

### Sidecar (7%)
echo "=== clean Sidecar ==="
kubectl create -f https://raw.githubusercontent.com/f0603026/CKAtest/main/exam/yaml/F6-pod-sidecar.yaml
echo "=== clean Sidecar done ==="

## Deployment 應用 - Scale (4%)
echo "=== clean Deployment - Scale ==="
kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;
kubectl create deployment loadbalancer --image=registry.k8s.io/echoserver:1.10 --replicas=0 2>/dev/null;
echo "=== clean Deployment - Scale done ==="

## cordon & drain (4%)
echo "=== clean cordon & drain ==="
kubectl uncordon ${cluster}-control-plane &>/dev/null
kubectl uncordon ${cluster}-worker &>/dev/null
kubectl uncordon ${cluster}-worker2 &>/dev/null
echo "=== clean cordon & drain done ==="

### NetworkPolicy (7%)
echo "=== clean NetworkPolicy ==="
kubectl delete networkpolicy -n internal allow-port-from-namespace 2>/dev/null;
kubectl delete networkpolicy -n echo allow-port-from-namespace 2>/dev/null;
kubectl create namespace internal 2>/dev/null
kubectl create namespace my-app 2>/dev/null
### 1. NetworkPolicy (7%)
kubectl create namespace internal 2>/dev/null;

### 2. NetworkPolicy (7%)
kubectl replace -f namespace my-app 2>/dev/null;
kubectl replace -f namespace echo 2>/dev/null;
echo "=== clean NetworkPolicy done ==="

## Service (7%)
echo "=== clean Service ==="
kubectl create deployment front-end --image=quay.io/cloudwalker/nginx 2>/dev/null;
echo "=== clean Service done ==="

### RBAC (Role-based Access Control) (4%) 
echo "=== clean RBAC ==="
kubectl delete -f ns app-team1 2>/dev/null;
kubectl create ns app-team1 2>/dev/null;
kubectl delete ClusterRole deployment-clusterrole 2>/dev/null;
kubectl delete sa cicd-token 2>/dev/null;
echo "=== clean RBAC done ==="
clear
