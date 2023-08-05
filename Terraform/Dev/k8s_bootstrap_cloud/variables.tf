
### - general

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "az" {
  description = "availability zone"
}

variable "tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "HA" {
  description = "High  Availability - to determinbe if the cluster uses multi control plane or not"
  type        = bool
}

### - names

variable "amis" {
  description = "Default AMIs to use for nodes depending on the region"
  type        = map(any)
}

variable "cluster_name" {
  description = "dynamic cluster name"
  type        = string
}

variable "elb_name" {
  description = "Name of the ELB for Kubernetes API"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
}

variable "k8s_cluster_dns" {
  description = "domain name of the k8s cluster"
}

### - ips

variable "vpc_cidr" {
  description = "vpc cidr range"
}

variable "control_cidr" {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "kubernetes_pod_cidr" {
  description = "cidr range for pods ip adds"
}


###

variable "instance_user" {
  description = "the user to run cmds in the instance - usually 'ununtu', or ec2-user"
}

variable "keypair_public_key" {
  description = "Public Key of the default keypair"
}

###

variable "ansibleFilter" {
  description = "`ansibleFilter` tag value added to all instances, to enable instance filtering in Ansible dynamic inventory"
}

variable "ansible_master_instance_type" {
  description = "the type for ansible-master instance vm"
}

###

variable "etcd_instance_type" {
}

variable "controller_instance_type" {
}

variable "worker_instance_type" {
}



# variable "node_config" {
#   description = "The total nodes configuration, List of Objects/Dictionary"
# }

# variable "env" {
#   type        = string
#   description = "environment"
# }