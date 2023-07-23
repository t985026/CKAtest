## Deployment 應用 - Scale (4%)

kubectl delete deploy presentation
kubectl delete deploy loadbalance

kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0
kubectl create deployment loadbalance --image=registry.k8s.io/echoserver:1.10 --replicas=0
