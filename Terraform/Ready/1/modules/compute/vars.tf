
variable "aws_region" {
  type        = string
  description = "aws region to provision resources in"
}

variable "gen_tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "HA" {
  description = "High  Availability - to determinbe if the cluster uses multi control plane or not"
  type        = bool
}

variable "az" {
  # type = list()
  description = "availability zones"
}

variable "amis" {
  description = "Default AMIs to use for nodes depending on the region"
  type        = map(any)
}

variable "keypair_name" {
  type        = string
  description = "Name of the KeyPair used for all instances"
}

variable "elb_name" {
  type        = string
  description = "Name of the ELB for Kubernetes API"
}

variable "nginx_port" {
  type        = number
  description = "port nginx will server to, should be opened in secrurity group and listen for in lb listener & healthcheck"
}

variable "ubuntu_instance_type" {
  type        = string
  description = "instance type to use with ubuntu instances"
}

variable "main_sg_id" {
  type        = string
  description = "main security group id"
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "public subnets ids"
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "private subnets ids"
}