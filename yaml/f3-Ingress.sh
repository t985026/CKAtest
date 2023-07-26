#!/bin/bash
echo "=== F3-Ingress build ==="
kubectl create ns ing-internal

echo 'apiVersion: v1
kind: Pod
metadata:
  name: hi
  namespace: ing-internal
  labels:
    name: hi
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
      name: http' > hi-pod.yaml

echo 'apiVersion: v1
kind: Service
metadata:
  name: hi
  namespace: ing-internal
  labels:
    name: hi
spec:
  selector:
    name: hi
  ports:
  - port: 80
    protocol: TCP
    targetPort: http
  sessionAffinity: None
  type: ClusterIP' > hi-svc.yaml

kubectl create -f hi-pod.yaml
kubectl create -f hi-svc.yaml

echo "=== F3-Ingress Done ==="




