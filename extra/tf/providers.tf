
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.47.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile    = "default"
  # shared_credentials_file = "~/.aws/credentials"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  # version                = "2.16.1" #"~> 1.11"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# module "helm_release" {
#   source = "git@gitlab.com:dviross/argo-infra.git"
# }
