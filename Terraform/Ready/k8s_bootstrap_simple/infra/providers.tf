terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2.1"
    }
  }

  required_version = ">= 1.1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Terraform   = "true"
      provisioner = "Terraform"
      Owner       = "roi.bandel@develeap.com"
      Creator     = "roi.bandel@develeap.com"
      Email       = "roi.bandel@develeap.com"
      Objective   = "Develeap Hub"
      Expiration  = "20231230"
    }
  }
}