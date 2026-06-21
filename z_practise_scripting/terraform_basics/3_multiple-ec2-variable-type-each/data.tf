data "aws_ami" "ami_al2023_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_iam_role" "vrp_iam_role" {
  name = var.vrp_iam_role
}

data "aws_key_pair" "vrp_pemkey" {
  key_name = var.vrp_pemkey
}

data "aws_security_group" "vrp_sg" {
  id = var.vrp_sg
}

data "aws_subnet" "vrp_pvt_subnet" {
  id = var.vrp_pvt_subnet
}
