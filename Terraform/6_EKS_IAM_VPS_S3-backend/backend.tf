# Backend configuration for saving and locking tfstate file

terraform {

  backend "s3" {
    bucket         = "vrp-doc-s3-123456789-devenv"
    key            = "platform/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = false
    dynamodb_table = "vrp-tfhcllock-dynamo-db"
  }
}