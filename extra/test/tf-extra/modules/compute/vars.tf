variable "ec2" {
  description = "ec2 components"
  type        = map(any)
}

variable "tags" {
  description = "general tags"
  type        = map(any)
}

variable "env" {
  description = "workspace, branch, environment"
  type        = string
}

variable "cidr_block" {
  description = "list of cidr blocks for subnets of main vpc"
  type        = list(string)
}

variable "ted_subnet_id" {
  description = "subnet var from network module"
  type        = string
}

variable "ted_sg_id" {
  description = "sequrity group var from network module"
  type        = string
}

variable "source_files" {
  description = "files to copy to ec2"
  type        = map(string)
}

variable "iam_profile" {
  description = "instance -ecr privilaged- iam profile - role"
  type        = string
}
