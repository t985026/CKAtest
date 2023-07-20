#!/bin/bash
cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)
rm *.yaml && echo 'remove all yaml' 
### Pod Logs (5%)
[ ! -d /opt/KUTR00101 ] && mkdir -p /opt/KUTR00101
[ -f /opt/KUTR00101/bar ] && rm /opt/KUTR00101/*
echo 'Pod Logs clear'

kubectl get pod | tail -n +2 | cut -d ' ' -f 1 > rmpod.tmp

while read pod
do
  kubectl delete pod ${pod}

done < rmpod.tmp
rm getpod.tmp rmpod.tmp

echo 'apiVersion: v1
kind: Pod
metadata:
  name: bar
spec:
  containers:
  - name: bar-container
    image: quay.io/cloudwalker/alpine
    command: ["/bin/sh"]
    args:
    - -c
    - |
      mkdir -p /var/log
      while true;
      do
        echo "unable-to-access-website"
        sleep 10
      done' > pod-log.yaml
kubectl apply -f pod-log.yaml

### Check Ready Node (4%)

[ ! -d /opt/KUSC00402/ ] && mkdir -p /opt/KUSC00402/
[ -d /opt/KUSC00402/ ] && rm /opt/KUSC00402/*
echo 'Check Ready Node clear'

### NodeSelector (4%)
kubectl label node ${cluster}-worker disk=spinning
### CPU (5%)
[ -d /opt/KUTR00401/ ] && rm /opt/KUTR00401/* && touch /opt/KUTR00401/KURT00401.txt
kubectl label node ${cluster}-worker2 name=cpu-loader


kubectl run cpu1 --image=quay.io/cloudwalker/sre.base --restart=Never --labels=name=cpu-loader -- stress-ng --cpu 2  --timeout 600s


### Sidecar (7%)
echo $'apiVersion: v1
kind: Pod
metadata:
  name: big-corp-app
spec:
  containers:
  - name: pod-sidecar
    image: quay.io/cloudwalker/alpine
    command: ["/bin/sh"]
    args:
    - -c
    - |
      mkdir -p /var/log;i=0;
      while true;
      do
        echo "$(date) INFO $i" >> /var/log/big-corp-app.log;
        i=$((i+1));sleep 1;
      done
' > pod-sidecar.yaml

kubectl create -f pod-sidecar.yaml
