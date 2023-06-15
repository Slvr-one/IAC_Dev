#!/bin/bash
set -eux

context="kind-terraform-learn"

---

ps -ef | grep etcd

--

kubectl cluster-info
kubectl version --client

kubectl config view --minify --flatten --context=$context

--

#kubectl get cs --> Warning: v1 ComponentStatus is deprecated in v1.19+
kubectl get --raw='/readyz?verbose' # curl -k <https://localhost:6443>/livez?verbose

--

kubectl get service -A -o json | jq '.items[] | select (.spec.type=="ClusterIP")' | jq '.metadata.name'

kubectl delete services $(kubectl get services --all-namespaces \
-o jsonpath='{range .items[?(@.spec.type=="LoadBalancer")]}{.metadata.name}{" -n "}{.metadata.namespace}{"\n"}{end}')

--

# Update a single-container pod's image version (tag) to v4
kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -

--

certs:
openssl x509 -in /etc/kubernetes/pki/<cert> -text -noout
# https://github.com/mmumshad/kubernetes-the-hard-way/tree/master/tools

--

# cfssl and cfssljson cli utils are used to provision PKI Infrastructure and generate TLS certs.
# Download and install cfssl and cfssljson:

# brew install cfssl

wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson

chmod +x cfssl cfssljson

sudo mv cfssl cfssljson /usr/local/bin/

# cfssl version && cfssljson --version

---

# Install kubectl:
wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

--

# etcd:

# Inspect the value assigned to data-dir on the etcd pod:
kubectl -n kube-system describe po etcd-cluster1-controlplane | grep data-dir


Check the members of the cluster:
(after ssh to external etcd server - (`ssh etcd-server`))

ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/etcd/pki/ca.pem \
    --cert=/etc/etcd/pki/etcd.pem \
    --key=/etc/etcd/pki/etcd-key.pem \
    member list

--

# inspect the endpoints and certificates used by the etcd pod to take the backup.
kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep advertise-client-urls

kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep pki

--


# SSH to controlplane, take a backup using the endpoints and certificates identified above:

ETCDCTL_API=3 etcdctl \
    --endpoints=https://10.1.220.8:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /opt/cluster1.db


# copy backup to the node. To do this, back to node and use scp:
scp cluster1-controlplane:/opt/cluster1.db /opt

--

# Copy snapshot file from node to etcd-server in the /root directory:
scp /opt/cluster2.db etcd-server:/root


# Restore  snapshot on the cluster2. 
# Since done directly on etcd-server, using endpoint https:/127.0.0.1, with same certificates that were identified earlier. 
# using /var/lib/etcd-data-new as data-dir

ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/etcd/pki/ca.pem \
    --cert=/etc/etcd/pki/etcd.pem \
    --key=/etc/etcd/pki/etcd-key.pem \
    snapshot restore /root/cluster2.db \
    --data-dir /var/lib/etcd-data-new

----

# Update systemd service unit file for etcd:
vi /etc/systemd/system/etcd.service, add the new value for data-dir:
{

[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
User=etcd
Type=notify
ExecStart=/usr/local/bin/etcd \
  --name etcd-server \
  --data-dir=/var/lib/etcd-data-new \ <-- (change to new data dir, thats all)

}

--

# set permissions correctly on the new directory (should be owned by etcd user):
chown -R etcd:etcd /var/lib/etcd-data-new
# ls -ld /var/lib/etcd-data-new/

--

# reload & restart etcd service.
systemctl daemon-reload 
systemctl restart etcd

--

# recommended to restart controlplane components 
# (e.g. kube-scheduler, kube-controller-manager, kubelet) 
# to ensure that they don't rely on some stale data.



