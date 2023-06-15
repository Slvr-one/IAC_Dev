
variable "cluster_name" {
  default     = ""
  description = "actual name of cluster"
}

variable "cluster" {
  type        = list(any)
  description = "cluster info"
}
variable "nodes_role" {
  description = "aws role for nodes premissions in cluster"
}

variable "cluster_role" {
  description = "aws role for cluster"
}

variable "private_subnets" {
  description = "private subnets for main cluster"

}

variable "public_subnets" {
  description = "public subnets for main cluster"

}

variable "nodes_policys_attach" {
  type        = list(any)
  description = "policies for nodes functionalities"
}

variable "cluster_policy_attach" {
  description = "policy for cluster functionalities"
}
# variable "oidc_issuer" {
#   type = list
#   description = "issuer for iam & tls use of oidc openid connect"
# }