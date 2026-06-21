terraform {
  backend "s3" {
    bucket       = "vrp-terraform-state"
    key          = "vrp/terraform.tfstate"
    region       = "us-east-1"
    profile      = "kvmk"
    use_lockfile = true
  }
}