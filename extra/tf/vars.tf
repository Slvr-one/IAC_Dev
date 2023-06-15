variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region"
}

variable "service_port" {
  type        = number
  default     = 5000
  description = "port & target port for app service"
}

variable "image" {
  default = "bookmaker"
}

variable "imageTag" {
  default = "latest"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment"
}

variable "cluster_name" {
  default     = "victor-11"
  description = "actual name of cluster"

}
variable "cluster" {
  type        = list(any)
  description = "cluster info"

  default = [
    {
      node_group = {
        instance_types = [""]
        # scaling_config = {
        #   desired_size = 1
        #   max_size     = 5
        #   min_size     = 0
        # }
      }
      # username = "role1"
      # groups   = ["system:masters"]
    },
  ]
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "tags" {
  type = map(any)
}