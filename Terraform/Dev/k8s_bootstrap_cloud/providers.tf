
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "2.9.0"
    # }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.19.0"
    # }
    # kubectl = { 
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.7.0"
    # }
  }

  backend "s3" {
    bucket         = "dvir-tf-state"
    key            = "dvir/tf.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-state"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile #"default"

  #   default_tags {
  #    tags = {
  #      Environment = "Test"
  #      Owner       = "Dviross"
  #      Project     = "k8s-bootstrap"
  #    }
  #  }
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1alpha1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       data.aws_eks_cluster.cluster.name
#     ]
#   }
# }

# provider "helm" {
#   kubernetes {
#     # config_path = "~/.kube/config"
#     host                   = module.eks.host
#     cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-id", module.eks.cluster_id]
#       # args        = ["eks", "get-token", "--cluster-name", module.eks.cluster.name]

#       command = "aws"
#     }
#   }
# }


  