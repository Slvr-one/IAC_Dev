variable "aws_profile" {
  type        = string
  description = "aws profile to use"
}

variable "aws_region" {
  type        = string
  description = "aws region to provision resources in"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
}

variable "ubuntu_instance_type" {
  description = "instance type to use with ubuntu instances"
}

variable "gen_tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "HA" {
  description = "High  Availability - to determinbe if needs more than 1 instance"
  type        = bool
}

/////


variable "amis" {
  description = "Default AMIs to use for instances depending on the region"
  type        = map(any)
}

/////

variable "vpc_cidr" {
  description = "vpc cidr range"
}

variable "vpc_name" {
  description = "name for main vpc"
}

variable "elb_name" {
  description = "Name of elastic load balancer"
}


variable "private_sb_count" {
  description = "number of private subnets"
}

variable "public_sb_count" {
  description = "number of public subnets"
}

variable "nginx_port" {
  type        = number
  description = "port nginx will server to, should be opened in secrurity group and listen for in lb listener & healthcheck"
}