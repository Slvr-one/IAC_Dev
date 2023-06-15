#!/bin/bash
set -euo pipefail


gcloud compute networks create k8s-one --subnet-mode custom

gcloud compute networks subnets create kubernetes \
  --network k8s-one \
  --range 10.240.0.0/24

gcloud compute firewall-rules create k8s-one-allow-internal \
  --allow tcp,udp,icmp \
  --network k8s-one \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

gcloud compute firewall-rules create k8s-one-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network k8s-one \
  --source-ranges 0.0.0.0/0

verify:
# gcloud compute firewall-rules list --filter="network:k8s-one"

gcloud compute addresses create k8s-one \
  --region $(gcloud config get-value compute/region)

verify:
# gcloud compute addresses list --filter="name=('k8s-one')"

---

provisioned using Ubuntu Server 20.04, with the containerd container runtime. 
Each compute instance provisioned with fixed private IP address

# Kubernetes Controllers:
for i in 0 1 2; do
  gcloud compute instances create controller-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2004-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.1${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags k8s-one,controller
done

# Kubernetes Workers:
for i in 0 1 2; do
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2004-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-standard-2 \
    --metadata pod-cidr=10.200.${i}.0/24 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags k8s-one,worker
done

verify:
# gcloud compute instances list --filter="tags.items=k8s-one"

gcloud compute ssh controller-0

---

configure certs for the cluster:

./certs.sh

---

Client Authentication Configs:
(generate kubeconfig files for the controller manager, kubelet, kube-proxy, and scheduler clients and the admin user.)

---

Kubernetes Public IP Address:

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe k8s-one \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

---

The kubelet Kubernetes Configuration File:

for instance in worker-0 worker-1 worker-2; do
  kubectl config set-cluster k8s-one \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-one \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done

---
The kube-proxy Kubernetes Configuration File:

{
  kubectl config set-cluster k8s-one \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-one \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}

---

The kube-controller-manager Kubernetes Configuration File:

{
  kubectl config set-cluster k8s-one \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-one \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}

---

The kube-scheduler Kubernetes Configuration File:

{
  kubectl config set-cluster k8s-one \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-one \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}

---

The admin Kubernetes Configuration File:

{
  kubectl config set-cluster k8s-one \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-one \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}

---

Distribute the Kubernetes Configuration Files:

for instance in worker-0 worker-1 worker-2; do
  gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done






