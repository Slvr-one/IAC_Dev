variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "gen_tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block range for vpc"
}

# variable "env" {
#   type        = string
#   description = "environment"
# }