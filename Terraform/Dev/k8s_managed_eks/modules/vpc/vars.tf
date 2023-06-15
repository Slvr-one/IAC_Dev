
variable "region" {
  description = "aws region to deploy to"
  type        = string
}

variable "tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "az" {
  description = "list of avalability zones avalable"
  # type        = map(any)
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "route_table_name" {
  type        = string
  description = "Route table description"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"
}

# variable "private_subnet_cidr_blocks" {
#   type        = list(string)
#   default     = ["10.0.0.0/24", "10.0.1.0/24"] #["10.0.0.0/19", "10.0.32.0/19"]
#   description = "CIDR block range for the private subnet"
# }

# variable "public_subnet_cidr_blocks" {
#   type        = list(string)
#   default     = ["10.0.2.0/24", "10.0.3.0/24"] #["10.0.64.0/19", "10.0.96.0/19"]
#   description = "CIDR block range for the public subnet"
# }

# variable "availability_zones" {
#   type        = list(string)
#   default     = ["eu-central-1a", "eu-central-1b"]
#   description = "List of availability zones for the selected region"
# }
