
# Terrraform configuration for creating an EC2 instance
resource "aws_instance" "vrp_test_ec2" {
  ami                         = var.vrp_ami
  instance_type               = var.vrp_instance_type
  iam_instance_profile        = var.vrp_iam_role
  key_name                    = var.vrp_pemkey
  vpc_security_group_ids      = [var.vrp_sg]
  subnet_id                   = var.vrp_pvt_subnet
  # If one ec2 need public ip, then we can use this below condition to assign public ip to only web server
  # associate_public_ip_address = each.key == "web" ? true : false

  tags = {
    Name       = "vrp_test_ec2"
    env        = "dev"
    app        = "vrp"
    managed-by = "terraform"
  }
}