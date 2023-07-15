#1
#建立指定工作目錄
sudo mkdir -p /opt/course/1
#賦予 root 以外使用者寫入權限
sudo chmod -R 757 /opt/course/

#2

#檢查指定 node 的 Taints 項目
kubectl describe node 91-m1 | grep 'Taints:'
Taints:             node-role.kubernetes.io/control-plane:NoSchedule

#移除指定 node 的 NoSchedule Taint
kubectl taint node 91-m1 node-role.kubernetes.io/control-plane:NoSchedule-
node/91-m1 untainted

#3

#建立題目指定 namespace
kubectl create ns project-c13

#4

#建立題目所需 service
nano service-am-i-ready.yaml
kind: Service
apiVersion: v1
metadata:
  name: service-am-i-ready
  namespace: default
  labels:
    id: cross-server-ready
spec:
  selector:
    id: cross-server-ready
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  type: ClusterIP

#建立 service service-am-i-ready
kubectl apply -f service-am-i-ready.yaml

#查看 svc 狀態
kubectl get svc -n default
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes           ClusterIP   172.16.128.1    <none>        443/TCP   22h
service-am-i-ready   ClusterIP   172.16.155.39   <none>        80/TCP    160m





#5

#建立指定工作目錄
sudo mkdir -p /opt/course/5

#賦予 root 以外使用者洩入權限
sudo chmod -R 757 /opt/course/


#6
kubectl create ns project-tiger

#7
#建立指定工作目錄
sudo mkdir -p /opt/course/7

#賦予 root 以外使用者洩入權限
sudo chmod -R 757 /opt/course/

#8

#建立指定工作目錄
sudo mkdir -p /opt/course/8

#賦予 root 以外使用者洩入權限
sudo chmod -R 757 /opt/course/












