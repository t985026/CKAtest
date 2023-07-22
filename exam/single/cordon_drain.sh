cluster=$(kubectl config view |grep 'cluster: ' | cut -d ':' -f 2)

## cordon & drain (4%)
kubectl uncordon ${cluster}-worker
kubectl uncordon ${cluster}-worker2
