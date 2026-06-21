terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configurations of AWS provider
provider "aws" {
  region  = "us-east-1"
  profile = "kvmk"
}