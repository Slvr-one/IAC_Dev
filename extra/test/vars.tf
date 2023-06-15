variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region"
}

variable "tags" {
  type = map(any)
}

variable "env" {
  type        = string
  default     = ""
  description = "environment"
}

variable "cluster_name" {
  default     = ""
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

#########################


# variable "cidr_block" {
#   description = "list of cidr blocks for subnets of main vpc"
#   type        = list(string)
# }


# variable "rules" {
#   description = "list of -rule- objects for main sg"
#   type        = list(any)
#   default = [{
#     protocol = "tcp"
#     port     = 22
#     cidr     = ["0.0.0.0/0"]
#     desc     = "SSH"
#     },
#     {
#       protocol = "tcp"
#       port     = 80
#       cidr     = ["0.0.0.0/0"]
#       desc     = "HTTP"
#     },
#     {
#       protocol = "tcp"
#       port     = 443
#       cidr     = ["0.0.0.0/0"]
#       desc     = "HTTPS"
#     },
#     {
#       protocol = "tcp"
#       port     = 9191
#       cidr     = ["0.0.0.0/0"]
#       desc     = "costum"
#   }]
# }

# variable "ec2" {
#   description = "instance type and key_pair name"
#   type        = map(string)
# }

# variable "user_data" {
#   description = "instances user data script"
#   type        = string
# }

# variable "source_files" {
#   type        = map(string)
#   description = "files to copy to ec2"
# }

########################


# variable "service_port" {
#   type        = number
#   default     = 5000
#   description = "port & target port for app service"
# }

# variable "image" {
#   default = "bookmaker"
# }

# variable "image_tag" {
#   default = "latest"
# }

# variable "map_accounts" {
#   description = "Additional AWS account numbers to add to the aws-auth configmap."
#   type        = list(string)

#   default = [
#     "777777777777",
#     "888888888888",
#   ]
# }

# variable "map_roles" {
#   description = "Additional IAM roles to add to the aws-auth configmap."
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = [
#     {
#       rolearn  = "arn:aws:iam::66666666666:role/role1"
#       username = "role1"
#       groups   = ["system:masters"]
#     },
#   ]
# }

# variable "map_users" {
#   description = "Additional IAM users to add to the aws-auth configmap."
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = [
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user1"
#       username = "user1"
#       groups   = ["system:masters"]
#     },
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user2"
#       username = "user2"
#       groups   = ["system:masters"]
#     },
#   ]
# }


