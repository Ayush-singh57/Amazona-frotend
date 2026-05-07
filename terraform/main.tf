terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Call your new CDN module
module "frontend_cdn" {
  source       = "./modules/cdn"
  project_name = var.project_name
}