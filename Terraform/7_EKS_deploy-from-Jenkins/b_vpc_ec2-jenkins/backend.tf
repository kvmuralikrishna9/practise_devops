# Backend configuration for saving and locking tfstate file

terraform {

  backend "s3" {
    bucket         = "eks-tf-s3-eks-jenkins-devenv"
    key            = "platform/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = false
    dynamodb_table = "eks-tf_eks-jenkins-dynamo-db"
  }
}
