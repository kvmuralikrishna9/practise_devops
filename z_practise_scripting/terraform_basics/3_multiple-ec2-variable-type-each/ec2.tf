resource "aws_instance" "vrp_test_ec2" {
  for_each = var.vrp_instance_type
  ami                         = data.aws_ami.ami_al2023_latest.id
  instance_type               = each.value
  iam_instance_profile        = data.aws_iam_role.vrp_iam_role.name
  key_name                    = data.aws_key_pair.vrp_pemkey.key_name
  vpc_security_group_ids      = [data.aws_security_group.vrp_sg.id]
  subnet_id                   = data.aws_subnet.vrp_pvt_subnet.id
  associate_public_ip_address = false

  tags = {
    Name       = each.key
    env        = "dev"
    app        = "vrp-web"
    managed-by = "terraform"
  }
}

