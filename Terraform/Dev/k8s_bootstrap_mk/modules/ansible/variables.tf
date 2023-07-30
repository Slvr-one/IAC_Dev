
variable "amis" {
  description = "Default AMIs to use for nodes depending on the region"
  type        = map(any)
}

variable "az" {
  description = "availability zone"
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "HA" {
  description = "High  Availability - to determinbe if the cluster uses multi control plane or not"
  type        = bool
}

variable "tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

# ###

variable "controllers" {
  description = "controllers hosts"
}

variable "workers" {
  description = "workers hosts"
}


variable "control-plane_sg_id" {
  description = "controllers security group"
}

variable "k8s_sg_id" {
  description = "cluster security group"
}

variable "k8s_subnet_id" {
  description = "subnet id of nodes"
}

# ###

variable "ansible_master_instance_type" {
  description = "the type for ansible-master instance vm"
}


# ###

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
}

variable "ssh_private_key" {
  description = "ref to private key to controle all instances, here for ansible master"
}