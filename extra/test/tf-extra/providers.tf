terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  # backend "s3" {
  #   bucket  = module.s3.bucket_id
  #   key     = "state/ted/terraform.tfstate"
  #   region  = "us-east-2" #main region (will not accept a var)
  #   encrypt = true
  # }

  backend "gcs" {
    bucket = "tf-backend-dvir"
    prefix = "argocd-tf"
    key = "" //
  }
}


# provider "tls" {}

provider "aws" {
  region = var.region
}


