terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "Terraform Mastery"
      Terraform   = "true"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Purpose     = "Terraform Mastery"
    }
  }
}


# Common AWS data
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
