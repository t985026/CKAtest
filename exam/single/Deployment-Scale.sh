## Deployment 應用 - Scale (4%)

kubectl delete deploy presentation 2> /dev/null;
kubectl delete deploy loadbalance 2> /dev/null;

kubectl create deployment presentation --image=registry.k8s.io/echoserver:1.10 --replicas=0 2> /dev/null;
kubectl create deployment loadbalance --image=registry.k8s.io/echoserver:1.10 --replicas=0 2> /dev/null;
