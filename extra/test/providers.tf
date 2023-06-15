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
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    kubectl = { //enabling the server-side apply on the kubectl provider.
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  # backend "s3" {
  #   bucket  = module.s3.bucket_id
  #   key     = "dvir-cluster/terraform.tfstate"
  #   region  = "eu-central-1" #main region (will not accept a var)
  #   encrypt = true
  # }

  # backend "gcs" {
  #   bucket = "tf-backend-dvir"
  #   prefix = "argocd-tf"
  #   # key = "" //
  # }
}

provider "aws" {
  region  = var.region
  profile = "default"
  # shared_credentials_file = "~/.aws/credentials"
}

provider "kubernetes" {
  host                   = module.eks.host
  cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
  token                  = module.eks.cluster_id.cluster.token #module.eks.cluster_auth.cluster.token
  # load_config_file       = false
  # version                = "2.16.1" #"~> 1.11"
}

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#     # host                   = module.eks.host
#     # cluster_ca_certificate = base64decode(module.eks.cluster.cluster.certificate_authority.0.data)
#     # client_certificate     = base64decode(module.eks.cluster.certificate_authority.0.client_certificate)
#     # client_key             = base64decode(module.eks.cluster.certificate_authority.0.client_key)
#   }
# }

provider "helm" {
  kubernetes {
    host                   = module.eks.host
    cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-id", module.eks.cluster_id]
      command     = "aws"
    }
  }
}

# provider "kubectl" {
#   config_path = "~/.kube/config"
#   host                   = module.eks.host
#   cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
#   client_certificate     = base64decode(module.eks.cluster.kube_config.0.client_certificate)
#   client_key             = base64decode(module.eks.cluster.kube_config.0.client_key)
# }
