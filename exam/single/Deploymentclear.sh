## Deployment 應用 - Scale (4%)

rm *deploy*.yaml &>/dev/null
echo 'remove all yaml' 

kubectl delete deploy presentation
kubectl delete deploy loadbalance

