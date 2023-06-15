#!/bin/bash
set -euo pipefail

# //////////////  VARS  //////////////////////////////////////

user="ubuntu"
private_key_file="~/.ssh/kp-one.pem"
inventory="modules/ansible/inventory.ini"

# //////////////  ANSIBLE presets & run playbook  //////////////////////////////////////

[
sudo chmod 777 '${path.module}/ansible_config/inventory.ini'
sudo cp '${path.module}/ansible_config/ansible.cfg' /etc/ansible/ansible.cfg
# echo ${var.ssh_private_key} > ${local.private_ssh_key}
ansible-playbook -i '${path.module}/ansible_config/inventory.ini' '${path.module}/ansible_config/install_kubernetes.yaml' --user ${local.ssh_user} # --key-file ${local.private_ssh_key}
]


pushd ../infra/
# ansible -i $inventory -m ping all --user $user --key-file $private_key_file
ansible-playbook -i $inventory modules/ansible/setup.yaml --user $user --key-file $private_key_file
popd


# --- k8s ---
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# # Set up Kubernetes configuration for regular user
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# # Install Flannel networking plugin
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k


# # Join worker nodes to cluster
# kubeadm token create --print-join-command > join.sh
# chmod +x join.sh

# # Run join.sh on worker nodes
# ansible-playbook join.yml -i ../terraform/inventory.ini --user <ssh_user> --key-file <path_to_ssh_key>

# ---

# /etc/ansible/ansible.cfg -->

# [defaults]
# inventory = /etc/myhosts.txt
# host_key_checking=False
# command_warnings=false


# ansible  all  --host-lists       ----> will give list of hosts

# ansibel  all  -m  ping           ----> will check wether hosts is pingable or not 

# R="" # resource lookup
# terraform state list | grep -wnio $R | xargs terraform state show

# ansible config copy ->
# [ ~/.ansible.cfg ]

# [defaults]
# remote_user = ubuntu
# host_key_checking = False
# inventory=/etc/ansible/hosts
# #private_key_file=~/.ssh/id_rsa_ansible_main.pem
# #command_warnings=false

# [ssh_connection]
# control_path=%(directory)s/%%h-%%r
# control_path_dir=~/.ansible/cp
# #pipelining = True
# scp_if_ssh = True