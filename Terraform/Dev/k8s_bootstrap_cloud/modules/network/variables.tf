
variable "tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "vpc_cidr" {
  default = "10.43.0.0/16"
}

variable "control_cidr" {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "ansible_master_cidr" {
  description = "CIDR of ansible master to ssh from"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "kubernetes"
}

variable "zone" {
  default = "eu-central-1a"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
}

variable "keypair_public_key" {
  description = "Public Key of the default keypair"
}
