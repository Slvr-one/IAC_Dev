
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.47.0" #"~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.16.1"
    # }
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "4.0.4"
    # }
    # kubectl = { //enabling the server-side apply on the kubectl provider.
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.7.0"
    # }
  }

#   backend "s3" {
#     bucket         = "dvir-tf-state"
#     key            = "dvir-cluster/terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "tf-state"
#     encrypt        = true
#   }
}

provider "aws" {
  region  = var.region
  profile = var.profile #"default"

  # default_tags {
  #   tags = var.tags
  # }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.host
    cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-id", module.eks.cluster_id]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

# provider "kubectl" {
#   apply_retry_count      = 10
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

  