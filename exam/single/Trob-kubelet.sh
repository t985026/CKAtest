## Trobleshooting - kubelet 故障(2%?)
which ssh &>/dev/null
[ $? != 0 ] && apt update && apt install -y ssh
apt install sudo
echo -e \root\\nroot\\n| passwd root &>/dev/null
systemctl stop kubelet
echo "127.0.0.1       localhost wk8s-node-0" | tee -a /etc/hosts 
echo "127.0.0.1       localhost ek8s-node-1" | tee -a /etc/hosts 
