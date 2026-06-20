resource "aws_instance" "vrp_test_ec2" {
  ami                         = var.vrp_ami
  instance_type               = var.vrp_instance_type
  iam_instance_profile        = var.vrp_iam_role
  key_name                    = var.vrp_pemkey
  vpc_security_group_ids      = [var.vrp_sg]
  subnet_id                   = var.vrp_pvt_subnet
  associate_public_ip_address = true
  region                      = var.vrp_region

  tags = {
    Name       = "vrp_test_ec2"
    env        = "dev"
    app        = "vrp"
    managed-by = "terraform"
  }
}

