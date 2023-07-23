
kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0
kubectl create deployment loadbalance --image=registry.k8s.io/echoserver:1.10 --replicas=0
