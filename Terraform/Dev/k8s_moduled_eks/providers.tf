
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }

  backend "s3" {
    bucket         = "dvir-tf-state"
    key            = "dvir-cluster/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-state"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile #"default"
  # alias  = "default" # this should match the named profile you used if at all

  default_tags {
    tags = var.gen_tags
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

# provider "kubernetes" {
#   # experiments {
#   #   manifest_resource = true
#   # }
#   host                   = data.aws_eks_cluster.cluster.endpoint # module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   # token = data.aws_eks_cluster_auth.cluster.token
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }
  