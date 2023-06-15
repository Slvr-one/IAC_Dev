terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
  }

  # backend "s3" {
  #   bucket         = "dev-tf-state-12867"
  #   key            = "dev/tf.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "tf-state"
  #   encrypt        = true
  # }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = var.gen_tags
  }
}