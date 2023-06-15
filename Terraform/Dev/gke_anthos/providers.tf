terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.67.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}