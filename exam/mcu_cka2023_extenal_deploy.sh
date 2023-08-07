#!/bin/bash
ls ~/bin/cka_function &> /dev/null || wget -q 'https://raw.githubusercontent.com/Bookman-W/CKA_Tutorial/main/script/cka_function' -O ~/bin/cka_function
source ~/bin/cka_function
set-text-color-variable

# === F1-Scale ===
curl -s 'https://raw.githubusercontent.com/Bookman-W/CKA_Tutorial/main/script/preprocess/f1_preprocess' | bash
echo "F1-Scale Done."

# === F2-Etcd ===
 ETCD_VER=v3.5.7
 ETCD_DIR=etcd-download
 DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download

 mkdir ${ETCD_DIR}
 cd ${ETCD_DIR}
 wget ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz
 tar -xzvf etcd-${ETCD_VER}-linux-amd64.tar.gz

 cd etcd-${ETCD_VER}-linux-amd64
 sudo cp etcdctl /usr/local/bin/

 sudo mkdir -p /var/lib/backup




